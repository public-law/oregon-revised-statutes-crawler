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

    # |> extract_heading_info
  end
end
