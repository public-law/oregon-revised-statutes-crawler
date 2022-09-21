defmodule CrawlersTest do
  @moduledoc """
  Test the ORS crawler.
  """
  use ExUnit.Case
  doctest Crawlers

  setup_all do
    {:ok, document} = Floki.parse_document(File.read!("test/fixtures/ors.aspx"))

    %{doc: document}
  end

  test "finds the correct # of Volumes", %{doc: doc} do
    volumes = Parser.volumes(doc)

    assert Enum.count(volumes) == 19
  end

  test "gets Volume 1 name", %{doc: doc} do
    volumes = Parser.volumes(doc)
    vol_1 = List.first(volumes)

    assert vol_1.name == "Courts, Oregon Rules of Civil Procedure"
  end
end
