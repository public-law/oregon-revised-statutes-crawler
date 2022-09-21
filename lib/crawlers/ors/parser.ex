import Enum, only: [at: 2, filter: 2, map: 2, uniq: 1]
import Regex, except: [split: 2]
import String, except: [at: 2, filter: 2]

alias Crawlers.ORS.Models.Volume
import Crawlers.Regex, only: [capture: 2]

defmodule Parser do
  @moduledoc """
  The Parser module is responsible for converting the response from the spider.
  """
  @spec volumes(Floki.html_tree()) :: list(Volume.t())
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
  @spec extract_chapter_range(binary) :: Range.t()
  defp extract_chapter_range(raw_string) do
    [first_chapter, last_chapter] =
      run(~r/Chapters (\w+)-(\w+)/u, raw_string, capture: :all_but_first)
      |> map(&to_integer/1)

    first_chapter..last_chapter
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

  #
  # TODO.
  #

  def parse(html) when is_binary(html) do
    # {:ok, document} = Floki.parse_document(html)

    # headings =
    #   document
    #   |> Floki.find("tbody[id^=titl]")
    #   |> Enum.map(fn e -> %{name: Floki.text(e)} end)

    %Elixir.Crawly.ParsedItem{items: [], requests: []}
  end

  def parse(%{body: html}), do: parse(html)

  # defp id(elem) do
  #   elem
  #   |> Floki.attribute("id")
  #   |> List.first("")
  # end
end
