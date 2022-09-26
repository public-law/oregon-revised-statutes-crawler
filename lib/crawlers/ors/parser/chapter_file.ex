import Enum, except: [split: 2]
import String, except: [slice: 2]

alias Crawlers.ORS.Models.Section
import Util, only: [group_with: 2]

defmodule Parser.ChapterFile do
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
      # |> Floki.filter_out("span:fl-contains('repealed by')")
      |> group_with(&first_section_paragraph?/1)

    raw_sections
    |> map(&new_section/1)
    |> reject(fn s -> s.name == "" end)
  end

  @spec new_section(list) :: Section.t()
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

    %Section{
      name: heading.name,
      number: heading.number,
      text: full_text,
      chapter_number: heading.number |> split(".") |> List.first()
    }
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
    plaintext_lines =
      heading_p
      |> Floki.text()
      |> trim
      |> split("\r\n")

    metadata = extract_heading_metadata(heading_p)
    maybe_heading_text = extract_heading_text(plaintext_lines)

    %{
      name: metadata.name,
      number: metadata.number,
      maybe_text: maybe_heading_text
    }
  end

  @spec extract_heading_metadata([binary]) :: %{name: any, number: any}
  def extract_heading_metadata(heading_p) do
    heading_p
    |> Floki.text()
    |> trim
    |> split("\r\n")
    |> take(2)
    |> cleanup
    |> then(fn [num, name] -> %{number: num, name: name} end)
    |> dbg()
  end

  defp extract_heading_text(lines) do
    lines
    |> slice(2..-1)
    |> join(" ")
  end

  defp cleanup([number, name]) do
    [number, trim_trailing(name, ".")]
  end

  defp cleanup([number]) when is_binary(number) do
    [number, ""]
  end

  defp cleanup(text) when is_binary(text) do
    text
    |> replace("\r\n", " ")
    |> replace(<<194, 160>>, " ")
    |> replace(~r/  +/, " ")
    |> replace("<p> ", "<p>")
    |> trim_trailing("<p></p>")
  end

  defp first_section_paragraph?(element) do
    b_elem = Floki.find(element, "b")

    b_elem != [] && trim(Floki.text(b_elem)) != "Note:"
  end
end
