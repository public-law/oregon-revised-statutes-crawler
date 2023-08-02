defmodule Crawlers.Oar.Parser do

  @spec parse_from_api :: Crawly.ParsedItem.t()
  def parse_from_api() do
    # The sessions to add, August 2023.
    # TODO: Figure out an intelligent way to determine this.
    raw_paths =
      SessionLaws.regular_session_pdfs(2022)
        ++ SessionLaws.special_session_pdfs(2021, 2)
        ++ SessionLaws.special_session_pdfs(2021, 1)

    json_data = raw_paths
      |> Enum.map(&form_the_url/1)
      |> Enum.map(&parse_to_json/1)


    %Elixir.Crawly.ParsedItem{
      items:    json_data,
      requests: []
    }
  end


  defp form_the_url(path) do
    path
    |> String.replace("http://", "https://")
    |> String.replace(~r{^/bills_laws}, "https://www.oregonlegislature.gov/bills_laws")
  end


  defp parse_to_json(url) do
    url
  end
end
