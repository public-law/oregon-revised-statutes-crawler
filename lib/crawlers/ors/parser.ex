import Enum
import String, only: [trim: 1]
alias Crawlers.ORS.Models.Volume

defmodule Parser do
  @moduledoc """
  The Parser module is responsible for converting the response from the spider.
  """
  @spec volumes(Floki.html_tree()) :: list(Volume.t())
  def volumes(document) do
    document
    |> extract_headings()
    |> filter(&String.match?(&1, ~r/Volume/))
    |> map(fn v -> %Volume{name: extract_volume_name(v), number: extract_volume_number(v)} end)
  end

  @spec extract_headings(Floki.html_tree()) :: list(binary)
  defp extract_headings(document) do
    document
    |> Floki.find("tbody[id^=titl]")
    |> map(&Floki.text/1)
    |> map(&trim/1)
    |> uniq()
  end

  #
  # Clean up a string like:
  #   "Volume : 01 - Courts, Oregon Rules of Civil Procedure - Chapters 1-55 (48)"
  # to:
  #   "Courts, Oregon Rules of Civil Procedure"
  #
  @spec extract_volume_name(binary) :: binary
  defp extract_volume_name(raw_string) do
    raw_string
    |> String.split("-")
    |> at(1)
    |> trim()
  end

  #
  # Clean up a string like:
  #   "Volume : 01 - Courts, Oregon Rules of Civil Procedure - Chapters 1-55 (48)"
  # to:
  #   1
  #
  @spec extract_volume_number(binary) :: integer
  defp extract_volume_number(raw_string) do
    raw_string
    |> String.split("-")
    |> at(0)
    |> String.split(":")
    |> at(1)
    |> trim()
    |> String.to_integer()
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
