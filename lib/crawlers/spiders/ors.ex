defmodule ORS do
  use Crawly.Spider
  require IEx

  @impl Crawly.Spider
  def base_url(), do: "https://www.oregonlegislature.gov/bills_laws/Pages/ORS.aspx"

  @impl Crawly.Spider
  def init() do
    [start_urls: ["https://www.oregonlegislature.gov/bills_laws/Pages/ORS.aspx"]]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    Crawlers.Parsers.ORS.parse(response)
  end
end
