defmodule Spider do
  @moduledoc """
  The Spider module is responsible for crawling the ORS website.
  """
  use Crawly.Spider

  @impl Crawly.Spider
  def base_url, do: "https://www.oregonlegislature.gov/bills_laws/Pages/ORS.aspx"

  @impl Crawly.Spider
  def init do
    [start_urls: ["https://www.oregonlegislature.gov/bills_laws/Pages/ORS.aspx"]]
  end

  @impl Crawly.Spider
  def parse_item(_response) do
    # Parser.parse(response)
  end
end
