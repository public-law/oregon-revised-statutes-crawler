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
    assert count(sections) == 33
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
        "<p>A criminal action in a justice court is commenced and proceeded in to final determination, and the judgment therein enforced, in the manner provided in the criminal procedure statutes, except as otherwise specifically provided by statute. [Amended by 1973 c.836 §329]</p>"
    end

    test "Last", %{sections_156: sections} do
      assert last(sections).text ==
        "<p>Justices of the peace shall have concurrent jurisdiction over all offenses committed under ORS 167.315 to 167.333 and 167.340. [Formerly 770.260; 1985 c.662 §14; 1999 c.788 §48]</p>"
    end
  end
end
