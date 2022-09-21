defmodule CrawlersTest do
  @moduledoc """
  Test the ORS crawler.
  """
  use ExUnit.Case

  setup_all do
    {:ok, document} = "test/fixtures/ors.aspx" |> File.read!() |> Floki.parse_document()
    volumes = Parser.volumes(document)

    %{volumes: volumes}
  end

  test "finds the correct # of Volumes", %{volumes: volumes} do
    assert Enum.count(volumes) == 19
  end

  test "Volume 1 name", %{volumes: volumes} do
    vol_1 = List.first(volumes)

    assert vol_1.name == "Courts, Oregon Rules of Civil Procedure"
  end

  test "Volume 1 number", %{volumes: volumes} do
    vol_1 = List.first(volumes)

    assert vol_1.number == 1
  end

  test "Volume 19 name", %{volumes: volumes} do
    vol_19 = List.last(volumes)

    assert vol_19.name == "Utilities, Vehicle Code, Watercraft, Aviation"
  end

  test "Volume 19 number", %{volumes: volumes} do
    vol_19 = List.last(volumes)

    assert vol_19.number == 19
  end
end
