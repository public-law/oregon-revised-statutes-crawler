defmodule Crawlers.Oar.Parser do

  @spec parse_from_api :: Crawly.ParsedItem.t()
  def parse_from_api() do

    # The sessions to add, August 2023.
    results =
      SessionLaws.regular_session_pdfs(2022)
        ++ SessionLaws.special_session_pdfs(2021, 2)
        ++ SessionLaws.special_session_pdfs(2021, 1)


    %Elixir.Crawly.ParsedItem{
      items:    results,
      requests: []
    }
  end
end
