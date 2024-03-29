defmodule OrsRedirectSpider do
  @moduledoc """
  The Spider module is responsible for crawling the ORS website and returning
  a list URL redirects.
  """
  use Crawly.Spider

  alias Parser.ChapterFile


  @ors_home_page   "https://www.oregonlegislature.gov/bills_laws/Pages/ORS.aspx"
  @chapter_root    "https://www.oregonlegislature.gov/bills_laws/ors/ors"


  @impl Crawly.Spider
  def base_url(), do: "https://www.oregonlegislature.gov/"


  @impl Crawly.Spider
  def init() do
    [start_urls: [@ors_home_page]]
  end


  @impl Crawly.Spider
  def parse_item(%{request_url: @ors_home_page} = response) do
    Logger.info("Parsing #{response.request_url}...")

    Parser.parse_home_page_for_redirects(response)
  end


  def parse_item(%{request_url: @chapter_root <> _} = response) do
    Logger.info("Parsing #{response.request_url}...")

    ChapterFile.parse_redirects(response.body)
  end

end
