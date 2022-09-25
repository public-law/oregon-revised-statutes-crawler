import Enum, only: [map: 2, join: 1]
import String, only: [replace: 3, split: 2, trim: 1, trim_trailing: 2]

alias Crawlers.ORS.Models.Section

defmodule Parser.ChapterFile do
  @moduledoc """
  Parse a chapter file.
  """
  def sub_chapters(_) do
    []
  end

  def sections(response) do
    raw_sections =
      response
      |> Floki.find("p")
      |> Floki.filter_out("[align=center]")
      |> Util.group_until(&first_section_paragraph?/1)

    raw_sections
    |> map(&new_section/1)
  end

  def new_section(elements) do
    {heading_p, remaining_ps} = List.pop_at(elements, 0)
    metadata = extract_heading_info(heading_p)

    remaining_text =
      remaining_ps
      |> map(&Floki.text/1)
      |> map(fn text -> "<p>#{text}</p>" end)
      |> join
      |> cleanup

    full_text =
      case extract_heading_text(heading_p) do
        "" -> remaining_text
        heading_text -> "<p>#{heading_text}</p>" <> remaining_text
      end

    %Section{
      name: metadata.name,
      number: metadata.number,
      text: full_text,
      chapter_number: metadata.number |> split(".") |> List.first()
    }
  end

  #
  # A typical section heading looks like this:
  #   "838.005 Definitions."
  #
  # Or this:
  #   "838.025 Election laws apply. (1) ORS chapter 255 governs the following:"
  #
  defp extract_heading_info(heading) do
    heading
    |> Floki.text()
    |> trim
    |> split("\r\n")
    |> Enum.take(2)
    |> cleanup
    |> make_new_section
  end

  #
  # A typical section heading looks like this:
  #   "838.005 Definitions."
  #
  # Or this:
  #   "838.025 Election laws apply. (1) ORS chapter 255 governs the following:"
  #
  defp extract_heading_text(heading) do
    heading
    |> Floki.text()
    |> trim
    |> split("\r\n")
    |> Enum.slice(2..-1)
    |> Enum.join(" ")
  end

  defp cleanup([number, name]) do
    [number, trim_trailing(name, ".")]
  end

  defp cleanup(text) do
    text
    |> String.replace("\r\n", " ")
    |> replace(<<194, 160>>, " ")
    |> replace(~r/  +/, " ")
    |> replace("<p> ", "<p>")
    |> trim_trailing("<p></p>")
  end

  defp make_new_section([number, name]) do
    %{name: name, number: number}
  end

  defp first_section_paragraph?(element) do
    Floki.find(element, "b") != []
  end
end
