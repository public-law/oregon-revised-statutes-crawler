defmodule ChapterFileComplexTest do
  @moduledoc """
  Test a 'complex' Chapter File, 837. It's complex because it has:

  * Sub-chapters,
  * Sub-sub-chapters,
  * Embedded tables, and
  * "Note" paragraphs on some Sections.

  The source file is served from:

  https://www.oregonlegislature.gov/bills_laws/ors/ors837.html

  The fixture was made by downloading it verbatim with curl.
  """
  import Enum
  import List
  import TestHelper

  use ExUnit.Case, async: true

  setup_all do
    dom =
      "ors837.html"
      |> fixture_file(cp1252: true)
      |> Floki.parse_document!()

    # The context data for the tests.
    %{
      sub_chapters: Parser.ChapterFile.sub_chapters(dom),
      sections: Parser.ChapterFile.sections(dom)
    }
  end

  test "finds the correct # of Sections", %{sections: sections} do
    # "38" arrived at from a manual count, only current sections.
    assert count(sections) == 38
  end

  @tag :skip
  test "finds the correct # of SubChapters", %{sub_chapters: sub_chapters} do
    assert empty?(sub_chapters)
  end

  describe "Section.chapter_number" do
    @tag :skip
    test "is correct", %{sections: sections} do
      assert all?(sections, &(&1.chapter_number == "837"))
    end
  end

  describe "Section.kind" do
    test "is 'section' for all Sections", %{sections: sections} do
      assert all?(sections, &(&1.kind == "section"))
    end
  end

  describe "Section.number" do
    test "First", %{sections: sections} do
      assert first(sections).number == "837.005"
    end

    test "Last", %{sections: sections} do
      assert last(sections).number == "837.998"
    end
  end

  describe "Section.name" do
    test "First", %{sections: sections} do
      assert first(sections).name ==
               "Exemptions of certain aircraft from requirements of registration; rules"
    end

    test "Last", %{sections: sections} do
      assert last(sections).name == "Civil penalties"
    end
  end

  describe "Section text" do
    test "First", %{sections: sections} do
      assert first(sections).text ==
               "<p>837.040 to 837.070 do not apply to:</p><p>(1) Aircraft owned by any person, firm or corporation and certificated by the appropriate federal agency for domestic or foreign scheduled air commerce;</p><p>(2) Military aircraft of the United States of America;</p><p>(3) Aircraft licensed by a foreign country with which the United States has reciprocal relations exempting aircraft registered by the United States, or any political subdivision thereof, from registration within such foreign country; or</p><p>(4) Classes of aircraft designated as exempt by rules adopted by the State Aviation Board. [Formerly 493.010; 2005 c.22 §520; 2005 c.75 §1]</p>"
    end

    @tag :skip
    test "Last", %{sections: sections} do
      assert last(sections).text ==
               "<p>Refunding bonds of the same character and tenor as those replaced thereby may be issued pursuant to a resolution adopted by the district board without submitting to the electors the question of authorizing the issuance of the bonds. [Formerly 494.140]</p>"
    end
  end
end
