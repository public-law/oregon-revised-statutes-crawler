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
    }
  end


  describe "Renumbers sections" do
    test "gets the correct number", %{sections_001: sections} do
      assert count(sections) == 2
    end

    test "gets the right data", %{sections_001: sections} do
      assert [["https://oregon.public.law/statutes/ors_1.165", "https://oregon.public.law/statutes/ors_1.185"] | _ ] = sections
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
