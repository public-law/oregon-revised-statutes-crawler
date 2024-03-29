defmodule ChaptersTest do
  @moduledoc """
  Test the ORS crawler.
  """
  use ExUnit.Case, async: true
  import List
  import Enum

  alias Crawlers.ORS.Models.Chapter

  setup_all do
    api_result =
      "test/fixtures/ors-chapters.json"
      |> File.read!()
      |> Jason.decode!()
      |> Map.get("Row")

    %{chapters: Parser.chapters(api_result)}
  end


  test "finds the correct # of Chapters", %{chapters: chapters} do
    chapter_count = 688

    assert count(chapters) == chapter_count
  end


  test "Former provisions chapters are returned", %{chapters: chapters} do
    names =
      chapters
      |> map(& &1.name)

    assert any?(names, &(&1 == "(Former Provisions)"))
  end


  test "Chapter 1 name", %{chapters: chapters} do
    first_chapter = first(chapters)

    assert %Chapter{name: "Courts and Judicial Officers Generally"} = first_chapter
  end

  test "Chapter 1 number", %{chapters: chapters} do
    first_chapter = first(chapters)

    assert first_chapter.number == "1"
  end

  test "Chapter 1 Title number", %{chapters: chapters} do
    first_chapter = first(chapters)

    assert first_chapter.title_number == "1"
  end

  test "Chapter 1 URL", %{chapters: chapters} do
    first_chapter = first(chapters)

    assert first_chapter.url == "https://www.oregonlegislature.gov/bills_laws/ors/ors001.html"
  end

  test "Chapter 1 Annotation URL", %{chapters: chapters} do
    first_chapter = first(chapters)

    assert first_chapter.anno_url ==
             "https://www.oregonlegislature.gov/bills_laws/ors/ano001.html"
  end

  test "Last Chapter name", %{chapters: chapters} do
    last_chapter = last(chapters)

    assert last_chapter.name == "Airport Districts"
  end

  test "Last Chapter number", %{chapters: chapters} do
    last_chapter = last(chapters)

    assert last_chapter.number == "838"
  end

  test "Last Chapter Title number", %{chapters: chapters} do
    last_chapter = last(chapters)

    assert last_chapter.title_number == "62"
  end

  test "Last Chapter URL", %{chapters: chapters} do
    last_chapter = last(chapters)

    assert last_chapter.url == "https://www.oregonlegislature.gov/bills_laws/ors/ors838.html"
  end

  test "Last Chapter Annotation URL", %{chapters: chapters} do
    last_chapter = last(chapters)

    assert last_chapter.anno_url == "https://www.oregonlegislature.gov/bills_laws/ors/ano838.html"
  end
end
