defmodule VolumesTest do
  @moduledoc """
  Test the ORS crawler.
  """
  import List
  use ExUnit.Case, async: true

  setup_all do
    document = "test/fixtures/ors.aspx" |> File.read!() |> Floki.parse_document!()
    volumes = Parser.volumes(document)

    %{volumes: volumes}
  end

  test "finds the correct # of Volumes", %{volumes: volumes} do
    assert Enum.count(volumes) == 19
  end

  test "Volume 1 name", %{volumes: volumes} do
    vol_1 = first(volumes)

    assert vol_1.name == "Courts, Oregon Rules of Civil Procedure"
  end

  test "Volume 1 number", %{volumes: volumes} do
    vol_1 = first(volumes)

    assert vol_1.number == 1
  end

  test "Volume 1 first & last chapters", %{volumes: volumes} do
    vol_1 = first(volumes)

    assert vol_1.chapter_range == [1, 55]
  end

  test "Volume 19 name", %{volumes: volumes} do
    vol_19 = last(volumes)

    assert vol_19.name == "Utilities, Vehicle Code, Watercraft, Aviation"
  end

  test "Volume 19 number", %{volumes: volumes} do
    vol_19 = last(volumes)

    assert vol_19.number == 19
  end

  test "Volume 19 first & last chapters", %{volumes: volumes} do
    vol_19 = last(volumes)

    assert vol_19.chapter_range == [756, 838]
  end

  test "Volume 3 name", %{volumes: volumes} do
    vol_3 = Enum.at(volumes, 2)

    assert vol_3.name == "Landlord-Tenant, Domestic Relations, Probate"
  end
end
