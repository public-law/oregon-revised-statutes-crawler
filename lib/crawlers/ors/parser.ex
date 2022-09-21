import Enum

defmodule Parser do
  @moduledoc """
  The Parser module is responsible for parsing the response from the spider.
  """

  def parse(html) when is_binary(html) do
    {:ok, document} = Floki.parse_document(html)

    headings =
      document
      |> Floki.find("tbody[id^=titl]")
      |> Enum.map(fn e -> %{name: Floki.text(e)} end)

    %Elixir.Crawly.ParsedItem{items: headings, requests: []}
  end

  def parse(%{body: html}), do: parse(html)

  def volumes(document) do
    document
    |> Floki.find("tbody[id^=titl]")
    |> map(&Floki.text/1)
    |> map(&String.trim/1)
    |> filter(&String.match?(&1, ~r/Volume/))
    |> uniq()
  end

  # defp id(elem) do
  #   elem
  #   |> Floki.attribute("id")
  #   |> List.first("")
  # end
end