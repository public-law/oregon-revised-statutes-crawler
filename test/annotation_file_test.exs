defmodule AnnotationFileTest do
  @moduledoc """
  Test the Annotations main page parsing..
  """
  use ExUnit.Case, async: true
  import TestHelper
  import Enum
  alias Parser.AnnotationFile


  setup_all do
    dom =
      "ano001.html"
      |> fixture_file(cp1252: true)
      |> Floki.parse_document!()

    %{annotations: AnnotationFile.annotations(dom)}
  end


  test "finds the correct # of Annotations", %{annotations: annos} do
    chapter_annotations = 1
    section_annotations = 19

    assert count(annos) == chapter_annotations + section_annotations
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
