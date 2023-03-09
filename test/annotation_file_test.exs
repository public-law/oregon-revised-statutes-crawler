defmodule AnnotationFileTest do
  @moduledoc """
  Test the Annotations main page parsing..
  """
  use ExUnit.Case, async: true
  import TestHelper
  import Util
  import Enum
  alias Parser.AnnotationFile

  setup_all do
    dom_001 =
      "ano001.html"
      |> fixture_file(cp1252: true)
      |> then(&clean_no_break_spaces/1)
      |> Floki.parse_document!()

    dom_002 =
      "ano002.html"
      |> fixture_file(cp1252: true)
      |> then(&clean_no_break_spaces/1)
      |> Floki.parse_document!()

    %{
      chapter_annotations_001: AnnotationFile.chapter_annotations(dom_001),
      chapter_annotations_002: AnnotationFile.chapter_annotations(dom_002),
      section_annotations_001: AnnotationFile.section_annotations(dom_001),
      section_annotations_002: AnnotationFile.section_annotations(dom_002)
    }
  end

  # test "finds one Chapter Annotation", %{chapter_annotations_001: annos} do
  #   assert count(annos) == 1
  # end

  # test "finds zero Chapter Annotations", %{chapter_annotations_002: annos} do
  #   assert count(annos) == 0
  # end

  test "finds all Section Annotations in 001", %{section_annotations_001: annos} do
    assert count(annos) == 18
  end

  test "finds all Section Annotations in 002", %{section_annotations_002: annos} do
    assert count(annos) == 4
  end

  # test "Former provisions chapters are not returned", %{chapters: chapters} do
  #   names =
  #     chapters
  #     |> map(& &1.name)

  #   assert all?(names, &(&1 != "(Former Provisions)"))
  # end

  # test "Chapter 1 name", %{chapters: chapters} do
  #   first_chapter = first(chapters)

  #   assert %Chapter{name: "Courts and Judicial Officers Generally"} = first_chapter
  # end

  # test "Chapter 1 number", %{chapters: chapters} do
  #   first_chapter = first(chapters)

  #   assert first_chapter.number == "1"
  # end

  # test "Chapter 1 Title number", %{chapters: chapters} do
  #   first_chapter = first(chapters)

  #   assert first_chapter.title_number == "1"
  # end

  # test "Chapter 1 URL", %{chapters: chapters} do
  #   first_chapter = first(chapters)

  #   assert first_chapter.url == "https://www.oregonlegislature.gov/bills_laws/ors/ors001.html"
  # end

  # test "Last Chapter name", %{chapters: chapters} do
  #   last_chapter = last(chapters)

  #   assert last_chapter.name == "Airport Districts"
  # end

  # test "Last Chapter number", %{chapters: chapters} do
  #   last_chapter = last(chapters)

  #   assert last_chapter.number == "838"
  # end

  # test "Last Chapter Title number", %{chapters: chapters} do
  #   last_chapter = last(chapters)

  #   assert last_chapter.title_number == "62"
  # end

  # test "Last Chapter URL", %{chapters: chapters} do
  #   last_chapter = last(chapters)

  #   assert last_chapter.url == "https://www.oregonlegislature.gov/bills_laws/ors/ors838.html"
  # end
end
