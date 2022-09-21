defmodule CrawlersTest do
  @moduledoc """
  Test the ORS crawler.
  """
  use ExUnit.Case
  doctest Crawlers

  setup_all do
    {:ok, document} = "test/fixtures/ors.aspx" |> File.read!() |> Floki.parse_document()
    volumes = Parser.volumes(document)

    %{doc: document, volumes: volumes}
  end

  test "finds the correct # of Volumes", %{volumes: volumes} do
    assert Enum.count(volumes) == 19
  end

  test "gets Volume 1 name", %{volumes: volumes} do
    vol_1 = List.first(volumes)

    assert vol_1.name == "Courts, Oregon Rules of Civil Procedure"
  end
end
