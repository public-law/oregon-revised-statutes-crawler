defmodule ChaptersTest do
  @moduledoc """
  Test the ORS crawler.
  """
  import List
  use ExUnit.Case, async: true

  setup_all do
    api_result =
      "test/fixtures/ors-chapters.json"
      |> File.read!()
      |> Jason.decode!()

    %{chapters: Parser.chapters(api_result)}
  end

  test "finds the correct # of Chapters", %{chapters: chapters} do
    assert Enum.count(chapters) == 688
  end

  test "Chapter 1 name", %{chapters: chapters} do
    first_chapter = first(chapters)

    assert first_chapter.name == "Courts and Judicial Officers Generally"
  end

  test "Chapter 1 number", %{chapters: chapters} do
    first_chapter = first(chapters)

    assert first_chapter.number == "1"
  end

  test "Chapter 1 Title number", %{chapters: chapters} do
    first_chapter = first(chapters)

    assert first_chapter.title_number == "1"
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
end
