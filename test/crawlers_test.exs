defmodule CrawlersTest do
  @moduledoc """
  Test the ORS crawler.
  """
  use ExUnit.Case
  doctest Crawlers

  setup_all do
    %{html: File.read!("test/fixtures/ors.aspx")}
  end

  test "greets the world" do
    assert Crawlers.hello() == :world
  end

  test "gets the correct # of Volumes", %{html: html} do
    volumes = Parser.parse(html).volumes

    assert Enum.count(volumes) == 19
  end
end
