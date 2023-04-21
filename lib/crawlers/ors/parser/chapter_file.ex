import Enum, except: [split: 2]
import String, except: [reverse: 1, slice: 2]

alias Crawlers.ORS.Models.Section
alias Util

require Logger

defmodule Parser.ChapterFile do
  def parse(%{body: html}), do: parse(html)

  def parse(html) when is_bitstring(html) do
    document = Floki.parse_document!(Util.cp1252_to_utf8(html))

    %Elixir.Crawly.ParsedItem{
      items: sections(document),
      requests: []
    }
  end


  @moduledoc """
  Parse a chapter file.
  """
  def sub_chapters(_) do
    []
  end


  @spec sections(Floki.html_tree()) :: [Section.t()]
  def sections(dom) do
    raw_sections =
      dom
      |> Floki.find("p")
      |> Floki.filter_out("[align=center]")
      |> Floki.filter_out("span:fl-contains('repealed by')")
      |> Util.group_with(&first_section_paragraph?/1)

    raw_sections
    |> map(&new_section/1)
    |> Util.cat_oks(&Logger.warn/1)
  end


  @spec new_section(list) :: {:error, any} | {:ok, Section.t()}
  def new_section(elements) do
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
      chapter_number: heading.number |> split(".") |> List.first()
    )
  end


  #
  # A typical section heading looks like this:
  #   "838.005\r\nDefinitions."
  #
  # Or this:
  #   "838.025\r\nElection laws apply.\r\n(1) ORS chapter 255 governs the following:"
  #
  @spec extract_heading_data(Floki.html_tree()) :: %{
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


  @spec extract_heading_metadata(Floki.html_tree()) :: %{name: any, number: any}
  def extract_heading_metadata(heading_p) do
    heading_p
    |> Floki.text()
    |> trim
    |> split("\r\n", parts: 2)
    |> cleanup
    |> then(fn [num, name] -> %{number: num, name: name} end)
  end


  @spec extract_heading_text(any) :: binary
  def extract_heading_text({"p", _attrs, [_meta_data, text_elems]}) do
    Floki.text(text_elems)
    |> replace("\r\n", " ")
    |> trim
  end


  def extract_heading_text(_), do: ""


  defp cleanup([number, name]) do
    [number, replace_rn(List.first(split(name, ".")))]
  end

  defp cleanup([number]) when is_binary(number) do
    [number, ""]
  end

  defp cleanup(text) when is_binary(text) do
    text
    |> replace("\r\n", " ")
    |> Util.clean_no_break_spaces()
    |> replace(~r/  +/, " ")
    |> replace("<p> ", "<p>")
    |> trim_trailing("<p></p>")
  end


  defp first_section_paragraph?(element) do
    b_elem = Floki.find(element, "b")
    b_elem != [] && trim(Floki.text(b_elem)) != "Note:"
  end


  defp replace_rn(text) do
    replace(text, "\r\n", " ")
  end
end
