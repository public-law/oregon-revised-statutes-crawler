defmodule AnnotationFileTest do
  @moduledoc """
  Test the Annotations main page parsing..
  """
  use ExUnit.Case, async: true
  import TestHelper
  import Util
  import Enum
  alias Parser.AnnotationFile

  setup_all do
    dom_001 =
      "ano001.html"
      |> fixture_file(cp1252: true)
      |> clean_no_break_spaces()
      |> convert_windows_line_endings()
      |> Floki.parse_document!()

    dom_002 =
      "ano002.html"
      |> fixture_file(cp1252: true)
      |> clean_no_break_spaces()
      |> convert_windows_line_endings()
      |> Floki.parse_document!()

    %{
      chapter_annotations_001: AnnotationFile.chapter_annotations(dom_001),
      chapter_annotations_002: AnnotationFile.chapter_annotations(dom_002),
      section_annotations_001: AnnotationFile.section_annotations(dom_001),
      section_annotations_002: AnnotationFile.section_annotations(dom_002)
    }
  end

  test "finds all Section Annotations in 001", %{section_annotations_001: annos} do
    assert count(annos) == 18
  end

  test "finds all Section Annotations in 002", %{section_annotations_002: annos} do
    assert count(annos) == 4
  end

  test "Section number - 1", %{section_annotations_001: [a | _]} do
    assert a.section_number == "1.001"
  end

  test "Section number - 2", %{section_annotations_002: [a | _]} do
    assert a.section_number == "2.510"
  end

  test "Section text - 1", %{section_annotations_001: [first | _]} do
    assert first.text_blocks == [
             "<h2>Law Review Citations</h2>",
             "<p>50 WLR 291 (2014)</p>"
           ]
  end

  test "Section text - 2", %{section_annotations_002: [first | _]} do
    assert first.text_blocks == [
             "<h2>Notes of Decisions</h2>",
             "<p>The Housing Authority is an agency for purposes of jurisdiction under this section. Housing Authority v. Bahr, 25 Or App 117, 548 P2d 514 (1976)</p>",
             "<h2>Law Review Citations</h2>",
             "<p>51 OLR 651 (1972); 50 WLR 291 (2014)</p>"
           ]
  end

  # test "finds one Chapter Annotation", %{chapter_annotations_001: annos} do
  #   assert count(annos) == 1
  # end

  # test "finds zero Chapter Annotations", %{chapter_annotations_002: annos} do
  #   assert count(annos) == 0
  # end

  test "Section text - 1.160", %{section_annotations_001: collection} do
    sec_1_160 = get_annotation("1.160", collection)

    assert sec_1_160.text_blocks == [
      "<h2>Notes of Decisions</h2>",
      "<h3>In general</h3>",
      "<p>The trial court did not err or abuse its discretion in allowing counsel for each party plaintiff to examine the witnesses. Wulff v. Sprouse-Reitz, Inc., 262 Or 293, 498 P2d 766 (1972)</p>",
      "<h3>Mode of procedure</h3>",
      "<p>This section does not authorize the prosecution of class actions. American Tbr. & Trading Co. v. First Nat. Bank of Oregon, 263 Or 1, 500 P2d 1204 (1972)</p>",
      "<p>In a writ of review proceeding, a circuit court evidentiary hearing on facts relevant to standing is “most comfortable” to the spirit of the statutes. Duddles v. City Council of West Linn, 21 Or App 310, 535 P2d 583 (1975)</p>"
    ]
  end

  def get_annotation(section_number, collection) do
    collection |> find(fn a -> a.section_number == section_number end)
  end
end
