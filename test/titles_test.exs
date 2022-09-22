import List

defmodule TitlesTest do
  @moduledoc """
  Test the ORS crawler.
  """
  use ExUnit.Case, async: true

  setup_all do
    document =
      "test/fixtures/ors.aspx"
      |> File.read!()
      |> Floki.parse_document!()

    %{titles: Parser.titles(document)}
  end

  test "finds the correct # of Titles", %{titles: titles} do
    assert Enum.count(titles) == 61
  end

  test "Title 1 name", %{titles: titles} do
    vol_1 = first(titles)

    assert vol_1.name == "Courts of Record; Court Officers; Juries"
  end

  test "Title 1 number", %{titles: titles} do
    vol_1 = first(titles)

    assert vol_1.number == "1"
  end
end