import Enum, only: [map: 2]
import String, only: [split: 3, trim: 1, trim_trailing: 2]

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
    heading = List.first(extract_heading_info([head]))

    text =
      tail
      |> map(&Floki.text/1)
      |> Enum.join("</p><p>")

    %{
      name: heading.name,
      number: heading.number,
      text: text
    }
  end

  #
  # A typical section heading looks like this:
  #   "838.005 Definitions."
  #
  defp extract_heading_info(headings) do
    headings
    |> map(&Floki.text/1)
    |> map(&trim/1)
    |> map(&trim_trailing(&1, "."))
    |> map(&split(&1, "\r\n", parts: 2))
    |> map(fn [number, name] -> %{name: name, number: number} end)
  end

  def first_section_paragraph?(element) do
    Floki.find(element, "b") != []
  end
end
