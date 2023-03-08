defmodule Parser.AnnotationFile do
  @moduledoc """
  They're listed at https://www.oregonlegislature.gov/bills_laws/Pages/Annotations.aspx
  """
  alias Crawlers.ORS.Models.ChapterAnnotation

  def parse(_) do
  end

  @spec chapter_annotations(Floki.html_tree()) :: [ChapterAnnotation.t()]
  def chapter_annotations(dom) do
    paragraphs =
      dom
      |> Floki.find("p")
      |> Enum.map(&Floki.text/1)

    paragraphs |> dbg

    []
  end
end
