defmodule Spider do
  @moduledoc """
  The Spider module is responsible for crawling the ORS website.
  """
  use Crawly.Spider

  @home_page "https://www.oregonlegislature.gov/bills_laws/Pages/ORS.aspx"

  @impl Crawly.Spider
  def base_url, do: "https://www.oregonlegislature.gov/"

  @impl Crawly.Spider
  def init do
    [start_urls: [@home_page]]
  end

  @impl Crawly.Spider
  def parse_item(%{status_code: 200, request_url: @home_page} = response) do
    Parser.parse_home_page(response)
  end

  def parse_item(%{status_code: 200} = response) do
    dbg(response)
    Parser.parse_chapter(response)
  end
end
