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

  import Crawlers.String
  import Util


  @spec parse(%{:body => binary, optional(any) => any}) :: Crawly.ParsedItem.t()
  def parse(%{body: html}) do
    document =
      html
      |> cp1252_to_utf8()
      |> clean_no_break_spaces()
      |> convert_windows_line_endings()
      |> Floki.parse_document!()

    %Elixir.Crawly.ParsedItem{
      items: section_annotations(document),
      requests: []
    }
  end


  @spec section_annotations(Floki.html_tree()) :: [SectionAnnotation.t()]
  def section_annotations(dom) do
    dom
    |> Floki.find("p")
    |> Enum.map(&Floki.text/1)
    |> Util.group_with(&raw_section_heading?/1)
    |> Enum.map(&make_section_annotation/1)
    |> Enum.map(fn {:ok, section} -> section end)
  end


  defp make_section_annotation(strings) do
    SectionAnnotation.new(
      section_number: List.first(strings) |> normalize_whitespace(),
      text_blocks: strings |> parse_text_blocks()
    )
  end


  defp parse_text_blocks(strings) do
    strings
    |> filter_text_blocks()
    |> Enum.flat_map(&to_block/1)
  end


  # Make a finished HTML block from a raw input string.
  defp to_block(string) do
    case string do
      "LAW REVIEW CITATIONS: " <> cites ->    ["<h2>Law Review Citations</h2>"] ++ to_block(cites)
      "ATTY. GEN. OPINIONS: "  <> opinions -> ["<h2>Attorney General Opinions</h2>"] ++ to_block(opinions)

      "LAW REVIEW CITATIONS" ->               ["<h2>Law Review Citations</h2>"]
      "ATTY. GEN. OPINIONS" ->                ["<h2>Attorney General Opinions</h2>"]
      "NOTES OF DECISIONS" ->                 ["<h2>Notes of Decisions</h2>"]

      "In general" ->                         ["<h3>In general</h3>"]
      "Mode of procedure" ->                  ["<h3>Mode of procedure</h3>"]
      "Generally" ->                          ["<h3>Generally</h3>"]

      _ ->                                    ["<p>#{string}</p>"]
    end
  end


  # Return the list of text blocks that we want to keep.
  defp filter_text_blocks(strings) do
    strings
    |> Enum.drop(2)
    |> Enum.map(&normalize_whitespace/1)
    |> Enum.reject(&blank?/1)
  end


  @spec chapter_annotations(Floki.html_tree()) :: [ChapterAnnotation.t()]
  def chapter_annotations(_dom) do
    []
  end


  #
  #  Examples:
  #    "      2.570"
  #    "      2.570 to 2.580"
  #
  @spec raw_section_heading?(binary) :: boolean
  defp raw_section_heading?(paragraph) when is_binary(paragraph) do
    paragraph
    |> String.match?(~r/^      \w+\.\w+(\sto\s\w+\.\w+)?$/)
  end
end
