defmodule TitlesTest do
  @moduledoc """
  Test the ORS crawler.
  """
  import List
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
    title_1 = first(titles)

    assert title_1.name == "Courts of Record; Court Officers; Juries"
  end

  test "Title 1 number", %{titles: titles} do
    title_1 = first(titles)

    assert title_1.number == "1"
  end

  test "Title 1 first & last chapters", %{titles: titles} do
    title_1 = first(titles)

    assert title_1.chapter_range == ["1", "11"]
  end

  test "Title 62 name", %{titles: titles} do
    title_62 = last(titles)

    assert title_62.name == "Aviation"
  end

  test "Title 62 number", %{titles: titles} do
    title_62 = last(titles)

    assert title_62.number == "62"
  end

  test "Title 62 chapter range", %{titles: titles} do
    title_62 = last(titles)

    assert title_62.chapter_range == ["835", "838"]
  end
end
