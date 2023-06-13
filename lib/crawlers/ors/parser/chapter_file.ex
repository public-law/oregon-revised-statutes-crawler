import Enum, except: [split: 2]
import String, except: [reverse: 1, slice: 2]

alias Crawlers.ORS.Models.Section
alias Util

require Logger

defmodule Parser.ChapterFile do
  @moduledoc """
  Parse a chapter file.
  """

  @section_number_regex ~r/^[[:digit:]][[:alnum:]]{0,3}\.[[:alnum:]]{3,4}\s/

  def parse(%{body: html}), do: parse(html)

  def parse(html) when is_bitstring(html) do
    document = Floki.parse_document!(Util.cp1252_to_utf8(html))

    %Elixir.Crawly.ParsedItem{
      items: sections(document),
      requests: []
    }
  end


  def sub_chapters(_) do
    []
  end


  @spec sections(Floki.html_tree) :: [Section.t()]
  def sections(dom) do
    paragraphs =
      dom
      |> Floki.find("p")

    filtered_paragraphs =
      paragraphs
      |> Floki.filter_out("[align=center]")
      |> Enum.reject(&repealed?/1)
      |> Enum.reject(&subchapter_heading?/1)
      |> Enum.reject(&subsubchapter_heading?/1)

    lists_of_paragraphs =
      filtered_paragraphs
      |> Util.group_with(&first_section_paragraph?/1)

    current_edition = edition(dom)

    lists_of_paragraphs
    |> map(fn p -> new_section(p, current_edition) end)
    |> Util.cat_oks(&Logger.warn/1)
  end


  @spec new_section(list, integer) :: {:error, any} | {:ok, Section.t()}
  def new_section(elements, edition) do
    {heading_p, remaining_ps} = List.pop_at(elements, 0)
    heading = extract_heading_data(heading_p)

    remaining_text =
      remaining_ps
      |> map(&Floki.text/1)
      |> map(fn text -> "<p>#{text}</p>" end)
      |> join
      |> cleanup

    full_text =
      case heading.maybe_text do
        "" -> remaining_text
        text -> "<p>#{text}</p>" <> remaining_text
      end

    Section.new(
      name: heading.name,
      number: heading.number,
      text: full_text,
      chapter_number: heading.number |> split(".") |> List.first(),
      edition: edition
    )
  end


  @spec edition(Floki.html_tree) :: integer
  @doc """
  Parse the ORS edition. E.g., 2021.
  """
  def edition(dom) do
    dom
    |> Floki.find("[align=center]")
    |> Enum.filter(fn p -> Floki.text(p) =~ ~r/^\d{4} EDITION$/ end)
    |> List.first()
    |> Floki.text()
    |> Crawlers.String.capture(~r/^(\d{4}) EDITION$/)
    |> to_integer()
  end


  @spec repealed?(Floki.html_tree) :: boolean
  @doc """
  A repealed paragraph has one `<b>` and the second `<span>` consists only
  of bracketed text containing "repealed by".
  """
  def repealed?(p) do
    b_count = count(Floki.find(p, "b"))

    if b_count == 1 do
      case Floki.find(p, "span") do
        [_span1, span2] ->
          span_text = Floki.text(span2) |> Html.replace_rn()
          span_text =~ ~r/ \[.*(repealed by|renumbered)/i
        _ ->
          false
      end
    else
      false
    end
  end


  @spec subchapter_heading?(Floki.html_tree) :: boolean
  @doc """
  A Subchapter title heading has text which consists only of uppercase letters
  and whitespace. It begins with an upper case string.
  """
  def subchapter_heading?(p) do
    Floki.text(p) =~ ~r/^[[:upper:]]+[[:upper:][:space:]]*$/
  end


  @spec subsubchapter_heading?(Floki.html_tree) :: boolean
  @doc """
  A Subsubchapter title heading has text in a parenthesis.
  """
  def subsubchapter_heading?(p) do
    Floki.text(p) =~ ~r/^\([[:alpha:][:space:]]*\)$/
  end


  #
  # A typical section heading looks like this:
  #   "838.005\r\nDefinitions."
  #
  # Or this:
  #   "838.025\r\nElection laws apply.\r\n(1) ORS chapter 255 governs the following:"
  #
  @spec extract_heading_data(Floki.html_tree) :: %{
          :maybe_text => binary(),
          :name => binary(),
          :number => binary()
        }
  def extract_heading_data(heading_p) do
    metadata = extract_heading_metadata(heading_p)
    maybe_heading_text = extract_heading_text(heading_p)

    %{
      name: metadata.name,
      number: metadata.number,
      maybe_text: maybe_heading_text
    }
  end


  @doc """
  The number and name are contained in `<b></b>`. The number is followed
  by `\\r\\n` and the name. The name runs until a period.
  """
  @spec extract_heading_metadata(Floki.html_tree) :: %{name: any, number: any}
  def extract_heading_metadata(heading_p) do
    cond do
      type_1_first_section_paragraph?(heading_p) ->
        extract_heading_metadata_type_1(heading_p)

      type_2_first_section_paragraph?(heading_p) ->
        extract_heading_metadata_type_2(heading_p)

      true -> raise "Unknown heading type"
    end
  end


  @spec extract_heading_metadata_type_1(Floki.html_tree) :: %{name: any, number: any}
  def extract_heading_metadata_type_1(heading_p) do
    heading_p
    |> Floki.find("b")
    |> Floki.text()
    |> trim
    |> replace("\r\n", "\n")  # Hack to handle when \n is used.
    |> split("\n", parts: 2)
    |> cleanup
    |> then(fn [num, name] -> %{number: num, name: name} end)
  end


  @spec extract_heading_metadata_type_2(Floki.html_tree) :: %{name: any, number: any}
  def extract_heading_metadata_type_2(_heading_p) do
    %{name: "Name goes here", number: "999.999"}
  end


  #
  #
  #
  @spec extract_heading_text(any) :: binary
  def extract_heading_text({"p", _attrs, [_meta_data, text_elems]}) do
    Floki.text(text_elems)
    |> Html.replace_rn()
    |> trim
  end


  def extract_heading_text(_), do: ""


  defp cleanup([number, name]) do
    [number, List.first(split(Html.replace_rn(name), "."))]
  end


  defp cleanup([number]) when is_binary(number) do
    [number, ""]
  end


  defp cleanup(text) when is_binary(text) do
    text
    |> Html.replace_rn()
    |> Util.clean_no_break_spaces()
    |> replace(~r/  +/, " ")
    |> replace("<p> ", "<p>")
    |> trim_trailing("<p></p>")
  end


  # A predicate that determines if the DOM element is a first paragraph.
  # It's in this file and not the Section Model because it's specific to
  # how a Section is formatted in this particular HTML document.
  @spec first_section_paragraph?(Floki.html_tree) :: boolean
  def first_section_paragraph?(p_elem) do
    type_1_first_section_paragraph?(p_elem) || type_2_first_section_paragraph?(p_elem)
  end


  @spec type_1_first_section_paragraph?(Floki.html_tree) :: boolean
  def type_1_first_section_paragraph?(p_elem) do
    b_text = Html.text_in(Floki.find(p_elem, "b"))

    b_text =~ @section_number_regex
  end


  @spec type_2_first_section_paragraph?(Floki.html_tree) :: boolean
  def type_2_first_section_paragraph?(p_elem) do
    b_text = Html.text_in(Floki.find(p_elem, "b"))
    p_text = Html.text_in(p_elem)

    (b_text =~ ~r/^[[:alpha:]]/) && (p_text =~ @section_number_regex)
  end
end
