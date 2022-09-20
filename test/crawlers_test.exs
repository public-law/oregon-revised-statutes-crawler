defmodule CrawlersTest do
  use ExUnit.Case
  doctest Crawlers

  test "greets the world" do
    assert Crawlers.hello() == :world
  end
end
