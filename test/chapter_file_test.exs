defmodule ChapterFileTest do
  @moduledoc """
  Test ability to parse a chapter file's sections.
  """
  import List
  use ExUnit.Case, async: true

  setup_all do
    file =
      "test/fixtures/ors838.html"
      |> File.read!()

    document =
      :erlyconv.to_unicode(:cp1252, file)
      |> Floki.parse_document!()

    %{
      sub_chapters: Parser.ChapterFile.sub_chapters(document),
      sections: Parser.ChapterFile.sections(document)
    }
  end

  test "finds the correct # of Sections", %{sections: sections} do
    assert Enum.count(sections) == 15
  end

  test "finds the correct # of SubChapters", %{sub_chapters: sub_chapters} do
    assert Enum.empty?(sub_chapters)
  end

  test "First section name", %{sections: sections} do
    first_section = first(sections)

    assert first_section.name == "Definitions"
  end

  test "First section number", %{sections: sections} do
    first_section = first(sections)

    assert first_section.number == "838.005"
  end

  test "Last section name", %{sections: sections} do
    last_section = last(sections)

    assert last_section.name == "Refunding bonds"
  end

  test "Last section number", %{sections: sections} do
    last_section = last(sections)

    assert last_section.number == "838.075"
  end

  # test "Chapter 1 Title number", %{sections: sections} do
  #   first_chapter = first(sections)

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
