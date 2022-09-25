defmodule ChapterFileSimpleTest do
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

  test "First section text", %{sections: sections} do
    first_section = first(sections)

    assert first_section.text ==
             "<p>As used in this chapter, unless the context requires otherwise:</p><p>(1) “District” means an airport district established under this chapter.</p><p>(2) “District board” means the governing body of the district. [Formerly 494.010]</p>"
  end

  # test "Last section text", %{sections: sections} do
  #   last_section = last(sections)

  #   assert last_section.text ==
  #            "The State Treasurer may refund any bonds issued under ORS 838.005 to 838.075 by issuing new bonds in the same amount and of the same maturity as the bonds to be refunded."
  # end
end
