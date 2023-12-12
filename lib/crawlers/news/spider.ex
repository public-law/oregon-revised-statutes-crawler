defmodule News.Spider do
  @moduledoc false
  use Crawly.Spider


  @impl Crawly.Spider
  def base_url(), do: "https://www.jdsupra.com"


  @impl Crawly.Spider
  def init() do
    [start_urls: ["https://www.jdsupra.com/legal-news/rss-law-feeds.aspx"]]
  end


  @impl Crawly.Spider
  def parse_item(response) do
    Logger.info("parse_item #{response.request_url}...")
  end
end
