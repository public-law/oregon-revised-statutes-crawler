defmodule ChapterFileHeadingVariant do
  @moduledoc """
  Chapter 156 has a non-bold section heading.
  """

  import Enum
  import List
  import TestHelper

  use ExUnit.Case, async: true

  setup_all do
    dom_156 =
      "ors156.html"
      |> fixture_file(cp1252: true)
      |> Floki.parse_document!()

    # The context data for the tests.
    %{
      sections_156: Parser.ChapterFile.sections(dom_156)
    }
  end


  test "finds the correct # of Sections - 156", %{sections_156: sections} do
    assert count(sections) == 70
  end


  describe "Section.number" do
    test "First", %{sections_156: sections} do
      assert first(sections).number == "156.010"
    end

    test "Last", %{sections_156: sections} do
      assert last(sections).number == "156.705"
    end

  end

  describe "Section.name" do
    test "156.074", %{sections_156: sections} do
      section =
        sections
        |> find(fn s -> s.number == "156.074" end)

      assert section
      assert section.name == "Unlawful factoring of payment card transaction"
    end
  end


  describe "Section text" do
    test "First", %{sections_156: sections} do
      assert first(sections).text ==
               "<p>ORS 837.015 and 837.040 to 837.070 do not apply to:</p><p>(1) Aircraft owned by any person, firm or corporation and certificated by the appropriate federal agency for domestic or foreign scheduled air commerce;</p><p>(2) Military aircraft of the United States of America;</p><p>(3) Aircraft licensed by a foreign country with which the United States has reciprocal relations exempting aircraft registered by the United States, or any political subdivision thereof, from registration within such foreign country; or</p><p>(4) Classes of aircraft designated as exempt by rules adopted by the State Aviation Board. [Formerly 493.010; 2005 c.22 §520; 2005 c.75 §1]</p>"
    end

    test "Last", %{sections_156: sections} do
      assert last(sections).text ==
               "<p>(1) Except as provided in subsection (2) of this section, in addition to any other penalty provided by law, the Director of the Oregon Department of Aviation may impose a civil penalty not to exceed $720 for each violation of any provision of this chapter or any rule adopted, or order issued, under this chapter.</p><p>(2) The director may impose a civil penalty not to exceed $2,500 for violation of ORS 837.080 or any rule adopted, or order issued, under this chapter to enforce ORS 837.080.</p><p>(3) The director shall impose civil penalties under this section in the manner provided in ORS 183.745. [2013 c.403 §2]</p>"
    end
  end
end
