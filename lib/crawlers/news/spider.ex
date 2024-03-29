alias Crawly.Utils
alias News.Article

defmodule News.Spider do
  @moduledoc false
  use Crawly.Spider

  @index           "https://www.jdsupra.com/legal-news/rss-law-feeds.aspx"
  @feed_prefix     "https://www.jdsupra.com/resources/syndication/docsRSSfeed.aspx"
  @article_prefix  "https://www.jdsupra.com/legalnews"
  @law_news_prefix "https://www.jdsupra.com/law-news/"

  @impl Crawly.Spider
  def base_url(), do: "https://www.jdsupra.com"


  @impl Crawly.Spider
  def init() do
    [start_urls: [@index]]
  end


  @impl Crawly.Spider
  def parse_item(%{request_url: @index} = response) do
    Logger.info("Parsing the feed index #{response.request_url}")

    feed_urls =
      response.body
      |> Floki.parse_document!
      |> Floki.find("li > a")
      |> Floki.attribute("href")
      |> Enum.map(&(request(&1, response.request.url)))

    %Crawly.ParsedItem{items: [], requests: feed_urls}
  end


  def parse_item(%{request_url: @feed_prefix <> _} = response) do
    Logger.info("Parsing RSS feed #{response.request_url}")

    article_urls =
      response.body
      |> Floki.parse_document!
      |> Floki.find("link")
      |> Enum.map(&Floki.text()/1)
      |> Enum.map(&Utils.request_from_url/1)

    %Crawly.ParsedItem{items: [], requests: article_urls}
  end


  def parse_item(%{request_url: @law_news_prefix <> _} = response) do
    Logger.info("Parsing law news #{response.request_url}")

    article_urls =
      response.body
      |> Floki.parse_document!
      |> Floki.find("h2 > a")
      |> Floki.attribute("href")
      |> Enum.map(fn url -> request(url, response.request.url) end)

    %Crawly.ParsedItem{items: [], requests: article_urls}

  end


  def parse_item(%{request_url: @article_prefix <> _} = response) do
    url = response.request_url
    Logger.info("Parsing article #{url}")

    article = Article.parse_from_html(response.body, url)

    %Crawly.ParsedItem{items: [%{url: url, article: article}], requests: []}
  end


  def parse_item(%{request_url: _} = response) do
    Logger.info("SKIPPING unknown #{response.request_url}")

    %Crawly.ParsedItem{items: [], requests: []}
  end


  def request(url, base_url) do
    url
    |> Utils.build_absolute_url(base_url)
    |> Utils.request_from_url()
  end
end
