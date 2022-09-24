defmodule Spider do
  @moduledoc """
  The Spider module is responsible for crawling the ORS website.
  """
  use Crawly.Spider

  @home_page "https://www.oregonlegislature.gov/bills_laws/Pages/ORS.aspx"
  @chapter_root "https://www.oregonlegislature.gov/bills_laws/ors/"

  @impl Crawly.Spider
  def base_url, do: "https://www.oregonlegislature.gov/"

  @impl Crawly.Spider
  def init do
    [start_urls: [@home_page]]
  end

  @impl Crawly.Spider
  def parse_item(%{request_url: @home_page} = response) do
    Parser.parse_home_page(response)
  end

  def parse_item(%{request_url: @chapter_root <> _} = response) do
    Parser.ChapterFile.parse(response)
  end
end
