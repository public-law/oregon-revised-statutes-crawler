defmodule Parser.AnnotationFile do
  @moduledoc """
  They're listed at https://www.oregonlegislature.gov/bills_laws/Pages/Annotations.aspx
  """
  import String, only: [replace: 3]
  alias Crawlers.ORS.Models.ChapterAnnotation


  def parse(_) do
  end


  @spec chapter_annotations(Floki.html_tree()) :: [ChapterAnnotation.t()]
  def chapter_annotations(dom) do
    annotations =
      dom
      |> Floki.find("p")
      |> Enum.map(&Floki.text/1)
      |> Enum.map(fn s -> replace(s, <<194, 160>>, " ") end)
      |> Util.group_with(&section_heading?/1)

    annotations |> dbg

    []
  end


  #
  # E.g.: "      2.570"
  #
  defp section_heading?(paragraph) when is_binary(paragraph) do
    paragraph =~ ~r/^.     \w+\.\w+$/
  end
end
