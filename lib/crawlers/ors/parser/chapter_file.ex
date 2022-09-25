import Enum, only: [map: 2]
import String, only: [split: 2, trim: 1, trim_trailing: 2]

defmodule Parser.ChapterFile do
  @moduledoc """
  Parse a chapter file.
  """
  def sub_chapters(_) do
    []
  end

  def sections(response) do
    # headings =
    #   response
    #   |> Floki.find("b")
    #   |> extract_heading_info

    raw_sections =
      response
      |> Floki.find("p")
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
      |> String.replace("\r\n", " ")

    text =
      case extract_heading_text(head) do
        "" -> text
        t -> t <> text
      end

    # |> String.replace(~r/\s\s+/, " ")

    %{
      name: heading.name,
      number: heading.number,
      text: "<p>" <> text <> "</p>"
    }
  end

  #
  # A typical section heading looks like this:
  #   "838.005 Definitions."
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

  defp make_new_section([number, name]) do
    %{name: name, number: number}
  end

  def first_section_paragraph?(element) do
    Floki.find(element, "b") != []
  end
end
