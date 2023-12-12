defmodule News.Spider do
  @moduledoc false
  use Crawly.Spider

  @index       "https://www.jdsupra.com/legal-news/rss-law-feeds.aspx"
  @feed_prefix "https://www.jdsupra.com/resources/syndication/docsRSSfeed.aspx"


  @impl Crawly.Spider
  def base_url(), do: "https://www.jdsupra.com"


  @impl Crawly.Spider
  def init() do
    [start_urls: ["https://www.jdsupra.com/legal-news/rss-law-feeds.aspx"]]
  end


  @impl Crawly.Spider
  def parse_item(%{request_url: @index} = response) do
    Logger.info("Parsing the feed index #{response.request_url}...")

    next_requests =
      response.body
      |> Floki.parse_document!
      |> Floki.find("li > a")
      |> Floki.attribute("href")
      |> Enum.map(fn url ->
        Crawly.Utils.build_absolute_url(url, response.request.url) |> Crawly.Utils.request_from_url()
      end)

    %{items: [], requests: next_requests}
  end

  def parse_item(response) do
    Logger.info("Parsing RSS feed #{response.request_url}...")

    %{items: [], requests: []}
  end
end
