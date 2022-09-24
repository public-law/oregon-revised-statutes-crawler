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
    response
    |> Floki.find("b")
    |> extract_heading_info
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
    element
    |> Floki.find("b")
    |> Enum.empty?()
  end
end
