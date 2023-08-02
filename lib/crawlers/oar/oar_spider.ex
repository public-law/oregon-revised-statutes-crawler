defmodule OarSpider do
  @moduledoc """
  The Spider module is responsible for crawling the ORS website.
  """
  use Crawly.Spider
  alias Crawlers.Oar.Parser


  @impl Crawly.Spider
  def base_url(), do: "https://www.public.law"


  @impl Crawly.Spider
  def init() do
    [start_urls: ["https://www.public.law/"]]
  end


  @impl Crawly.Spider
  def parse_item(_response) do
    Parser.parse_from_api()
  end
end
