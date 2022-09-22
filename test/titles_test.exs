defmodule TitlesTest do
  @moduledoc """
  Test the ORS crawler.
  """
  use ExUnit.Case, async: true

  setup_all do
    document = "test/fixtures/ors.aspx" |> File.read!() |> Floki.parse_document!()

    %{titles: Parser.titles(document)}
  end

  test "finds the correct # of Titles", %{titles: titles} do
    assert Enum.count(titles) == 61
  end
end
