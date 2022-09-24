import Enum, only: [map: 2]

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
    |> dbg
  end
end
