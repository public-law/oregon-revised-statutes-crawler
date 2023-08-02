defmodule Crawlers.Oar.Parser do

  @spec parse_from_api :: Crawly.ParsedItem.t()
  def parse_from_api() do
    results = SessionLaws.regular_session_pdfs(2022)


    %Elixir.Crawly.ParsedItem{
      items: results,
      requests: []
    }
  end
end
