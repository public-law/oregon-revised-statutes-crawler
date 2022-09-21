import Enum
alias Crawlers.ORS.Models.Volume

defmodule Parser do
  @moduledoc """
  The Parser module is responsible for converting the response from the spider.
  """
  @spec volumes(Floki.html_tree()) :: list(Volume.t())
  def volumes(document) do
    document
    |> Floki.find("tbody[id^=titl]")
    |> map(&Floki.text/1)
    |> map(&String.trim/1)
    |> filter(&String.match?(&1, ~r/Volume/))
    |> uniq()
    |> map(&extract_volume_name/1)
    |> map(fn n -> %Volume{name: n} end)
  end

  #
  # Clean up a string like:
  #   "Volume : 01 - Courts, Oregon Rules of Civil Procedure - Chapters 1-55 (48)"
  # to:
  #   "Courts, Oregon Rules of Civil Procedure"
  #
  defp extract_volume_name(raw_string) do
    raw_string
    |> String.split("-")
    |> at(1)
    |> String.trim()
  end

  # def parse(html) when is_binary(html) do
  #   {:ok, document} = Floki.parse_document(html)

  #   headings =
  #     document
  #     |> Floki.find("tbody[id^=titl]")
  #     |> Enum.map(fn e -> %{name: Floki.text(e)} end)

  #   %Elixir.Crawly.ParsedItem{items: headings, requests: []}
  # end

  # def parse(%{body: html}), do: parse(html)

  # defp id(elem) do
  #   elem
  #   |> Floki.attribute("id")
  #   |> List.first("")
  # end
end
