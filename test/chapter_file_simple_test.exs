defmodule ChapterFileSimpleTest do
  @moduledoc """
  Test a 'simple' Chapter File, 838. It's simple because it has no
  sub-chapters, no sub-sub-chapters, and no embedded tables or forms
  in the sections. The original file is served from:

  https://www.oregonlegislature.gov/bills_laws/ors/ors838.html

  The fixture was made by downloading it verbatim with curl.
  """
  import Enum
  import List
  import TestHelper
  use ExUnit.Case, async: true

  setup_all do
    dom =
      "ors838.html"
      |> fixture_file(cp1252: true)
      |> Floki.parse_document!()

    # The context data for the tests.
    %{
      sub_chapters: Parser.ChapterFile.sub_chapters(dom),
      sections: Parser.ChapterFile.sections(dom)
    }
  end

  test "finds the correct # of Sections", %{sections: sections} do
    assert count(sections) == 15
  end

  test "finds the correct # of SubChapters", %{sub_chapters: sub_chapters} do
    assert empty?(sub_chapters)
  end

  describe "Section.kind" do
    test "is 'section' for all Sections", %{sections: sections} do
      assert all?(sections, fn s -> s.kind == "section" end)
    end
  end

  describe "Section.number" do
    test "First", %{sections: sections} do
      first_section = first(sections)

      assert first_section.number == "838.005"
    end

    test "Last", %{sections: sections} do
      last_section = last(sections)

      assert last_section.number == "838.075"
    end
  end

  describe "Section.name" do
    test "First", %{sections: sections} do
      first_section = first(sections)

      assert first_section.name == "Definitions"
    end

    test "Last", %{sections: sections} do
      last_section = last(sections)

      assert last_section.name == "Refunding bonds"
    end
  end

  describe "Section text" do
    test "First", %{sections: sections} do
      first_section = first(sections)

      assert first_section.text ==
               "<p>As used in this chapter, unless the context requires otherwise:</p><p>(1) “District” means an airport district established under this chapter.</p><p>(2) “District board” means the governing body of the district. [Formerly 494.010]</p>"
    end

    test "Last", %{sections: sections} do
      last_section = last(sections)

      assert last_section.text ==
               "<p>Refunding bonds of the same character and tenor as those replaced thereby may be issued pursuant to a resolution adopted by the district board without submitting to the electors the question of authorizing the issuance of the bonds. [Formerly 494.140]</p>"
    end
  end
end
