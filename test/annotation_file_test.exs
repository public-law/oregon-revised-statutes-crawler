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
      |> Floki.parse_document!()

    dom_002 =
      "ano002.html"
      |> fixture_file(cp1252: true)
      |> clean_no_break_spaces()
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

  @tag :skip
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
end
