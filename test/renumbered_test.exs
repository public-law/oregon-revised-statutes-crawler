defmodule RenumberedTest do
  @moduledoc """
  Test `Parser.ChapterFile.renumbered_sections`.
  The fixture was made by downloading it verbatim with curl.
  """
  import Enum
  import TestHelper

  use ExUnit.Case, async: true

  setup_all do
    # The context data for the tests.
    %{
      sections_001: Parser.ChapterFile.renumbered_sections(parsed_fixture("ors001.html")),
      sections_165: Parser.ChapterFile.renumbered_sections(parsed_fixture("ors165.html")),
      sections_181: Parser.ChapterFile.renumbered_sections(parsed_fixture("ors181.html")),
      sections_343: Parser.ChapterFile.renumbered_sections(parsed_fixture("ors343.html"))
    }
  end


  describe "Chapter 001" do
    test "gets the correct number", %{sections_001: sections} do
      assert count(sections) == 2
    end

    test "gets the right data", %{sections_001: sections} do
      assert [
        "https://oregon.public.law/statutes/ors_1.165",
        "https://oregon.public.law/statutes/ors_1.185"] = hd(sections)
    end
  end


  describe "Chapter 165" do
    test "gets the correct number", %{sections_165: sections} do
      assert count(sections) == 1
    end

    test "gets the right data", %{sections_165: sections} do
      assert [
        "https://oregon.public.law/statutes/ors_165.107",
        "https://oregon.public.law/statutes/ors_165.117"] = hd(sections)
    end
  end


  describe "Chapter 181" do
    test "gets the correct number", %{sections_181: sections} do
      assert count(sections) == 198
    end

    test "the first redirect", %{sections_181: sections} do
      assert [
        "https://oregon.public.law/statutes/ors_181.010",
        "https://oregon.public.law/statutes/ors_181A.010"] = hd(sections)
    end
  end


  describe "Chapter 343" do
    test "gets the correct number", %{sections_343: sections} do
      assert count(sections) == 29
    end

    test "returns the missing redirect", %{sections_343: sections} do
      assert [
        "https://oregon.public.law/statutes/ors_343.187",
        "https://oregon.public.law/statutes/ors_339.623"] = Enum.at sections, 5
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
