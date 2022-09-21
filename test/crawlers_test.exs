defmodule CrawlersTest do
  @moduledoc """
  Test the ORS crawler.
  """
  use ExUnit.Case
  doctest Crawlers

  setup_all do
    %{doc: Floki.parse_document(File.read!("test/fixtures/ors.aspx"))}
  end

  test "greets the world" do
    assert Crawlers.hello() == :world
  end

  test "gets the correct # of Volumes", %{doc: doc} do
    volumes = Parser.volumes(doc)

    assert Enum.count(volumes) == 19
  end
end
