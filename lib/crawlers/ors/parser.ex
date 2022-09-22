import Enum, only: [at: 2, filter: 2, map: 2, uniq: 1]
import String, except: [at: 2, filter: 2]

alias Crawlers.ORS.Models.Volume
import Crawlers.Regex, only: [capture: 2]

defmodule Parser do
  @moduledoc """
  The Parser module is responsible for converting the response from the spider.
  """
  @spec volumes(Floki.html_tree()) :: [Volume.t()]
  def volumes(document) do
    document
    |> extract_headings()
    |> filter(&String.match?(&1, ~r/Volume/))
    |> map(fn v ->
      %Volume{
        name: extract_volume_name(v),
        number: extract_volume_number(v),
        chapter_range: extract_chapter_range(v)
      }
    end)
  end

  #
  # Parse out the visible text of the Volume and Title headings.
  #
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
  #   Range(1, 55)
  #
  @spec extract_chapter_range(binary) :: [pos_integer]
  defp extract_chapter_range(raw_string) do
    raw_string
    |> capture(~r/Chapters (\w+)-(\w+)/u)
    |> map(&to_integer/1)
  end

  #
  # Convert a raw Volume heading like:
  #   "Volume : 01 - Courts, Oregon Rules of Civil Procedure - Chapters 1-55 (48)"
  # to:
  #   "Courts, Oregon Rules of Civil Procedure"
  #
  @spec extract_volume_name(binary) :: binary
  defp extract_volume_name(raw_string) do
    raw_string
    |> split(" - ")
    |> at(1)
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
    |> capture(~r/Volume : (\d+)/u)
    |> at(0)
    |> to_integer
  end

  def parse(html) when is_binary(html) do
    document = Floki.parse_document!(html)

    %Elixir.Crawly.ParsedItem{items: volumes(document), requests: []}
  end

  def parse(%{body: html}), do: parse(html)

  # defp id(elem) do
  #   elem
  #   |> Floki.attribute("id")
  #   |> List.first("")
  # end
end
