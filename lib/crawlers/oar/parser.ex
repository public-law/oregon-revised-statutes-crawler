defmodule Crawlers.Oar.Parser do

  @spec parse_from_api :: Crawly.ParsedItem.t()
  def parse_from_api() do
    # The sessions to add, August 2023.
    # TODO: Figure out an intelligent way to determine this.
    raw_paths =
      SessionLaws.regular_session_pdfs(2022)
        ++ SessionLaws.special_session_pdfs(2021, 2)
        ++ SessionLaws.special_session_pdfs(2021, 1)

    urls = raw_paths
      |> Enum.map(&cleanup_path/1)


    %Elixir.Crawly.ParsedItem{
      items:    urls,
      requests: []
    }
  end


  defp cleanup_path(path) do
    path
    |> String.replace("http://", "https://")
    |> String.replace(~r/^\/bills_laws/, "https://www.oregonlegislature.gov/bills_laws")
  end
end
