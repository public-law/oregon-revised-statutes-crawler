defmodule Parser.AnnotationFile do
  @moduledoc """
  An annotation HTML page has this format:

  Chapter [number]
  [Optional Annotation Content]
  [Section Records]

  Each Section Record has this format:

  [Section Heading]
  [Annotation Content]

  A Section Heading can be either a _single_ section or a _range_ of sections.

  The Annotation Content is a mix of paragraph styles: Headings in all caps, paragraphs
  separated by blank lines with occasional embedded bold text, Sub-headings in bold,
  Notes in bold, and maybe more.

  The best Annotation Content strategy is probably to capture the
  formatting in simple HTML.

  All the annotations are listed at
  https://www.oregonlegislature.gov/bills_laws/Pages/Annotations.aspx
  """
  alias Crawlers.ORS.Models.ChapterAnnotation
  alias Crawlers.ORS.Models.SectionAnnotation
  import Util

  def parse(_) do
  end

  @spec section_annotations(Floki.html_tree()) :: [SectionAnnotation.t()]
  def section_annotations(dom) do
    dom
    |> Floki.find("p")
    |> Enum.map(&Floki.text/1)
    |> Util.group_with(&section_heading?/1)
  end

  @spec chapter_annotations(Floki.html_tree()) :: [ChapterAnnotation.t()]
  def chapter_annotations(_dom) do
    []
  end

  #
  # Examples:
  #   "      2.570"
  #   "      2.570 to 2.580"
  #
  defp section_heading?(paragraph) when is_binary(paragraph) do
    cleaned = clean_windows_line_endings(paragraph)
    cleaned =~ ~r/^      \w+\.\w+( to \w+\.\w+)?$/
  end
end
