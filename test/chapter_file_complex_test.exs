defmodule ChapterFileComplexTest do
  @moduledoc """
  Test 'complex' Chapter Files, 837 & 001. They're complex because it has:

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
    # The context data for the tests.
    %{
      sub_chapters: Parser.ChapterFile.sub_chapters(parsed_fixture("ors837.html")),
      sections:     Parser.ChapterFile.sections(parsed_fixture("ors837.html")),
      sections_72A: Parser.ChapterFile.sections(parsed_fixture("ors072A.html")),
      sections_001: Parser.ChapterFile.sections(parsed_fixture("ors001.html")),
      sections_156: Parser.ChapterFile.sections(parsed_fixture("ors156.html")),
      sections_165: Parser.ChapterFile.sections(parsed_fixture("ors165.html")),
      sections_275: Parser.ChapterFile.sections(parsed_fixture("ors275.html"))
    }
  end


  test "finds the correct # of Sections", %{sections: sections} do
    # "38" arrived at from a manual count, only current sections.
    assert count(sections) == 38
  end

  test "finds the correct # of Sections - 001", %{sections_001: sections} do
    # "98" arrived at from a manual count, only current sections.
    assert count(sections) == 98
  end

  test "finds the correct # of Sections - 165", %{sections_165: sections} do
    # See https://github.com/public-law/website/issues/1340
    assert count(sections) == 70
  end


  # @tag :skip
  # test "finds the correct # of SubChapters", %{sub_chapters: sub_chapters} do
  #   assert empty?(sub_chapters)
  # end

  describe "Section.chapter_number" do
    test "is correct", %{sections: sections} do
      assert all?(sections, &(&1.chapter_number == "837"))
    end

    test "is correct - 72A", %{sections_72A: sections} do
      assert all?(sections, &(&1.chapter_number == "72A"))
    end

    test "is correct - 001", %{sections_001: sections} do
      assert all?(sections, &(&1.chapter_number == "1"))
    end
  end

  describe "Section.kind" do
    test "is 'section' for all Sections", %{sections: sections} do
      assert all?(sections, &(&1.kind == "section"))
    end

    test "is 'section' for all Sections - 001", %{sections_001: sections} do
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

    test "First - 72A", %{sections_72A: sections} do
      assert [%{number: "72A.1010"} | _] = sections
    end

    test "Last - 72A", %{sections_72A: sections} do
      assert [%{number: "72A.5310"} | _] = reverse(sections)
    end

    test "First - 001", %{sections_001: sections} do
      assert [%{number: "1.001"} | _] = sections
    end

    test "Last - 001", %{sections_001: sections} do
      assert [%{number: "1.860"} | _] = reverse(sections)
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

    test "Weird truncated name", %{sections_001: sections} do
      sec_1_005 = get_section("1.005", sections)

      assert sec_1_005.name ==
               "Credit card transactions for fees, security deposits, fines and other court-imposed obligations; rules"
    end

    test "1.745", %{sections_001: sections} do
      # https://github.com/public-law/website/issues/1319
      sec_1_745 = get_section("1.745", sections)

      assert sec_1_745
      assert sec_1_745.name == "Laws on civil pleading, practice and procedure deemed rules of court until changed"
    end

    test "165.074", %{sections_165: sections} do
      section = get_section("165.074", sections)

      assert section
      assert section.name == "Unlawful factoring of payment card transaction"
    end
  end


  describe "Section text" do
    test "First", %{sections: sections} do
      assert first(sections).text ==
               "<p>ORS 837.015 and 837.040 to 837.070 do not apply to:</p><p>(1) Aircraft owned by any person, firm or corporation and certificated by the appropriate federal agency for domestic or foreign scheduled air commerce;</p><p>(2) Military aircraft of the United States of America;</p><p>(3) Aircraft licensed by a foreign country with which the United States has reciprocal relations exempting aircraft registered by the United States, or any political subdivision thereof, from registration within such foreign country; or</p><p>(4) Classes of aircraft designated as exempt by rules adopted by the State Aviation Board. [Formerly 493.010; 2005 c.22 §520; 2005 c.75 §1]</p>"
    end


    test "Last", %{sections: sections} do
      assert last(sections).text ==
               "<p>(1) Except as provided in subsection (2) of this section, in addition to any other penalty provided by law, the Director of the Oregon Department of Aviation may impose a civil penalty not to exceed $720 for each violation of any provision of this chapter or any rule adopted, or order issued, under this chapter.</p><p>(2) The director may impose a civil penalty not to exceed $2,500 for violation of ORS 837.080 or any rule adopted, or order issued, under this chapter to enforce ORS 837.080.</p><p>(3) The director shall impose civil penalties under this section in the manner provided in ORS 183.745. [2013 c.403 §2]</p>"
    end


    test "at Subchapter end", %{sections_165: sections} do
      # Test for a bug where the following Subchapter title is incorrectly
      # appended to a section's text.
      sec_572 = get_section("165.572", sections)

      assert sec_572.text ==
        "<p>(1) A person commits the crime of interference with making a report if the person, by removing, damaging or interfering with a telephone line, telephone or similar communication equipment, intentionally prevents or hinders another person from making a report to a law enforcement agency, a law enforcement official or an agency charged with the duty of taking public safety reports or from making an emergency call as defined in ORS 403.105.</p><p>(2) Interference with making a report is a Class A misdemeanor. [1999 c.946 §1; 2015 c.247 §30]</p>"
    end


    test "at Subsubchapter end", %{sections: sections} do
      # Test for a bug where the following Subsubchapter title is incorrectly
      # appended to a section's text.
      sec_100 = get_section("837.100", sections)

      assert sec_100.text ==
        "<p>In addition to any other persons permitted to enforce violations, the Director of the Oregon Department of Aviation and any employee specifically designated by the director may issue citations for violations established under ORS 837.990 in the manner provided by ORS chapter 153. [Formerly 493.225; 1991 c.460 §11; 1999 c.1051 §114; 2011 c.597 §148]</p>"
    end


    test "72A.5295", %{sections_72A: sections} do
      # The problem seems to be: New lines are used as a delimiter in the initial <p>.
      # Instead, the <b> and not-<b> should be used.
      sec_5295 = get_section("72A.5295", sections)

      assert sec_5295.text ==
               "<p>In addition to any other recovery permitted by this chapter or other law, the lessor may recover from the lessee an amount that will fully compensate the lessor for any loss of or damage to the lessor’s residual interest in the goods caused by the default of the lessee. [1993 c.646 §21]</p>"
    end


    test "1.745", %{sections_001: sections} do
      # https://github.com/public-law/website/issues/1319
      sec_1_745 = get_section("1.745", sections)

      assert sec_1_745
      assert sec_1_745.text ==
               "<p>All provisions of law relating to pleading, practice and procedure, including provisions relating to form and service of summons and process and personal and in rem jurisdiction, in all civil proceedings in courts of this state are deemed to be rules of court and remain in effect as such until and except to the extent they are modified, superseded or repealed by rules which become effective under ORS 1.735. [1977 c.890 §5; 1979 c.284 §2]</p>"
    end
  end


  describe "Section edition" do
    test "First 72A", %{sections_72A: sections} do
      assert first(sections).edition == 2021
    end

    test "Last 72A", %{sections_72A: sections} do
      assert last(sections).edition == 2021
    end

    test "First 001", %{sections_001: sections} do
      assert first(sections).edition == 2021
    end

    test "Last 001", %{sections_001: sections} do
      assert last(sections).edition == 2021
    end
  end


  describe "Malformed section bugfix" do
    # https://github.com/public-law/website/issues/1360

    test "finds the correct # of Sections", %{sections_156: sections} do
      # "33" arrived at from a manual count, only current sections
      assert count(sections) == 33
    end

    test "156.460 text shows only its own content", %{sections_156: sections} do
      sec_156_460 = get_section("156.460", sections)

      assert sec_156_460
      assert sec_156_460.text ==
        "<p>When committed, the defendant shall be delivered to the custody of the proper officer by any peace officer to whom the justice may deliver the commitment, first indorsing thereon, substantially, as follows: “I hereby authorize and command E. F. to deliver this commitment, together with the defendant therein named, to the custody of the sheriff of the County of ______.”</p>"
    end

    test "156.510 text is correct", %{sections_156: sections} do
      sec_156_510 = get_section("156.510", sections)

      assert sec_156_510
      assert sec_156_510.text ==
        "<p>If in the course of the trial it appears to the justice that the defendant has committed a crime not within the jurisdiction of a justice court, the justice shall dismiss the action, state in the entry the reasons therefor, hold the defendant upon the warrant of arrest and proceed to examine the charge as upon an information of the commission of crime.</p>"
    end

    test "156.510 name is correct", %{sections_156: sections} do
      sec_156_510 = get_section("156.510", sections)

      assert sec_156_510
      assert sec_156_510.name ==
        "Proceeding when crime is not within jurisdiction of justice court"
    end
  end


  describe "275.020 bugfix" do
    test "the section was parsed", %{sections_275: sections} do
      sec_275_020 = get_section("275.020", sections)

      assert sec_275_020
    end

    test "it has the correct name", %{sections_275: sections} do
      sec_275_020 = get_section("275.020", sections)

      assert sec_275_020
      assert sec_275_020.name == "Form and effect of conveyance to county"
    end
  end


  #
  # Helpers
  #

  @doc """
  Search for a section in a list of them.
  """
  def get_section(number, collection) do
    collection |> find(fn s -> s.number == number end)
  end

  def parsed_fixture(filename) do
    filename
      |> fixture_file(cp1252: true)
      |> Floki.parse_document!()
  end
end
