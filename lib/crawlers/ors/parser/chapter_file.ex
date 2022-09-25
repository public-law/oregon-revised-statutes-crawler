import Enum, only: [map: 2]
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
    {head, tail} = List.pop_at(elements, 0)
    heading = extract_heading_info(head)

    text =
      tail
      |> map(&Floki.text/1)
      |> Enum.join("</p><p>")
      |> wrap_in_p_tags
      |> cleanup

    text =
      case extract_heading_text(head) do
        "" -> text
        t -> "<p>#{t}</p>" <> text
      end

    %Section{
      name: heading.name,
      number: heading.number,
      text: text,
      chapter_number: heading.number |> split(".") |> List.first()
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

  defp wrap_in_p_tags(text) do
    "<p>" <> text <> "</p>"
  end
end
