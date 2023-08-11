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

  @spec parse(binary | %{:body => binary}) :: Crawly.ParsedItem.t
  def parse(%{body: html}), do: parse(html)

  def parse(html) when is_bitstring(html) do
    document =
      html
      |> Util.convert_from_windows_text()
      |> Floki.parse_document!()

    %Elixir.Crawly.ParsedItem{
      items: sections(document),
      requests: []
    }
  end


  @spec parse_redirects(binary | %{:body => binary}) :: Crawly.ParsedItem.t
  def parse_redirects(%{body: html}), do: parse_redirects(html)

  def parse_redirects(html) when is_bitstring(html) do
    document =
      html
      |> Util.convert_from_windows_text()
      |> Floki.parse_document!()

    %Elixir.Crawly.ParsedItem{
      items: renumbered_sections(document),
      requests: []
    }
  end


  def sub_chapters(_) do
    []
  end


  @spec sections(Floki.html_tree) :: [Section.t]
  def sections(dom) do
    paragraphs =
      dom
      |> Floki.find("p")

    filtered_paragraphs =
      paragraphs
      |> Floki.filter_out("[align=center]")
      |> Enum.reject(fn p -> repealed?(p) || subchapter_heading?(p) || subsubchapter_heading?(p) end)

    lists_of_paragraphs =
      filtered_paragraphs
      |> Util.group_with(&first_section_paragraph?/1)

    current_edition = edition(dom)

    lists_of_paragraphs
    |> map(fn p -> new_section(p, current_edition) end)
    |> Util.cat_oks(&Logger.warning/1)
  end


  def renumbered_sections(dom) do
    paragraphs =
      dom
      |> Floki.find("p")

    renumbered_toc_entries =
      paragraphs
      |> Enum.filter(fn p -> renumbered?(p) end)
      |> Enum.map( fn p -> Floki.find(p, "span") end )
      |> Enum.map( fn [span1, span2] -> [Floki.text(span1), Floki.text(span2)] end )
      |> Enum.map(&parse_both_spans/1)
      |> Enum.reject(&is_nil/1)
      |> Enum.map( fn items -> Enum.map(items, &make_url/1) end )

    renumbered_toc_entries
  end


  def parse_both_spans([span1, span2]) do
    original =
      span1
      |> trim()
      |> Crawlers.String.capture(~r/([0-9A-Z]+\.[0-9A-Z]+)/i)

    renumbered =
      span2
      |> trim()
      |> Crawlers.String.capture(~r/renumbered\s\s?([0-9A-Z]+\.[0-9A-Z]+)/i)

    if is_nil(renumbered) do
      nil
    else
      [original, renumbered]
    end
  end


  def make_url(section_number) do
    "https://oregon.public.law/statutes/ors_#{section_number}"
  end



  @spec new_section(list, integer) :: {:error, any} | {:ok, Section.t}
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
          span_text = Floki.text(span2) |> Util.remove_newlines()
          span_text =~ ~r/ \[.*(repealed by|renumbered)/i
        _ ->
          false
      end
    else
      false
    end
  end


  def renumbered?(node) do
    node
    |> Floki.text()
    |> String.contains?(["renumbered", "Renumbered"])
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
          :maybe_text => binary,
          :name => binary,
          :number => binary
        }
  def extract_heading_data(heading_p) do
    metadata = extract_heading_metadata(heading_p)
    maybe_heading_text =
      cond do
        type_1_first_section_paragraph?(heading_p) ->
          extract_heading_text_type_1(heading_p)

        type_2_first_section_paragraph?(heading_p) ->
          extract_heading_text_type_2(heading_p)

        true -> "Unknown heading type"
      end

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
  @spec extract_heading_metadata(Floki.html_tree) :: %{name: binary, number: binary}
  def extract_heading_metadata(heading_p) do
    cond do
      type_1_first_section_paragraph?(heading_p) ->
        extract_heading_metadata_type_1(heading_p)

      type_2_first_section_paragraph?(heading_p) ->
        extract_heading_metadata_type_2(heading_p)

      true -> raise "Unknown heading type"
    end
  end


  @doc """
          <p class=MsoNormal style='margin-bottom:0in;line-height:normal;text-autospace:
        none'>
            <b>
                <span style='font-size:12.0pt;font-family:"Times New Roman",serif'>      156.520
                Function of district attorney in justice court.</span>
            </b>
            <span style='font-size:12.0pt;font-family:"Times New Roman",serif'> The district
            attorney may prosecute an action and if requested by the court shall prosecute
            an action in a justice court and attend an examination before a magistrate,
            either in person or by someone appointed by the district attorney for that
            purpose, and in any case the district attorney shall control the proceedings on
            behalf of the state. [Amended by 1981 c.863 §1]</span>
        </p>

  """
  @spec extract_heading_metadata_type_1(Floki.html_tree) :: %{name: binary, number: binary}
  def extract_heading_metadata_type_1(heading_p) do
    heading_p
    |> Floki.find("b")
    |> Floki.text()
    |> trim()
    |> Util.remove_newlines()
    |> split(" ", parts: 2)
    |> cleanup
    |> then(fn [num, name] -> %{number: num, name: name} end)
  end


  @spec extract_heading_metadata_type_2({<<_::8>>, any, [{<<_::32>>, any, [...]}, ...]}) :: %{
          name: binary,
          number: binary
        }
  @doc """
        <p class=MsoNormal style='margin-bottom:0in;line-height:normal;text-autospace:none'>
          <span style='font-size:12.0pt;font-family:"Times New Roman",serif'>
                    156.510
              <b>Proceeding when crime is not within jurisdiction of justice court.</b>
                If in
              the course of the trial it appears to the justice that the defendant has
              committed a crime not within the jurisdiction of a justice court, the justice
              shall dismiss the action, state in the entry the reasons therefor, hold the
              defendant upon the warrant of arrest and proceed to examine the charge as upon
              an information of the commission of crime.
          </span>
        </p>
  """
  def extract_heading_metadata_type_2({"p", _, [{"span", _, [number_node, name_node, _body_node]}]}) do
    name =
      name_node
      |> Floki.text()
      |> Util.remove_trailing_period()

    number =
      number_node
      |> String.trim()

    %{name: name, number: number}
  end


  @spec extract_heading_text_type_1(any) :: binary
  def extract_heading_text_type_1({"p", _, [_meta_data, text_elems]}) do
    Html.text_in(text_elems)
  end

  def extract_heading_text_type_1(_),  do: ""


  @spec extract_heading_text_type_2({<<_::8>>, any, [{<<_::32>>, any, [...]}, ...]}) :: binary
  def extract_heading_text_type_2({"p", _, [{"span", _, [_number_text, _name_node, body_text]}]}) do
    Util.remove_newlines(String.trim(body_text))
  end


  defp cleanup([number, name]) do
    [number, Util.remove_trailing_period(Util.remove_newlines(name))]
  end


  defp cleanup([number]) when is_binary(number) do
    [number, ""]
  end


  defp cleanup(text) when is_binary(text) do
    text
    |> Util.remove_newlines()
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
