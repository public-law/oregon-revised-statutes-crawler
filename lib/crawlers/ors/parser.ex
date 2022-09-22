import Enum, only: [at: 2, filter: 2, map: 2, uniq: 1]
import String, except: [at: 2, filter: 2]

alias Crawlers.ORS.Models.Volume
alias Crawlers.ORS.Models.Title
import Crawlers.String, only: [capture: 2, captures: 2]

defmodule Parser do
  @moduledoc """
  The Parser module is responsible for converting the response from the spider.
  """

  @spec titles(Floki.html_tree()) :: [Title.t()]
  def titles(document) do
    document
    |> extract_headings()
    |> filter(&String.match?(&1, ~r/Title/))
    |> map(fn v ->
      %Title{
        name: extract_title_name(v),
        number: extract_title_number(v),
        chapter_range: extract_chapter_range_from_title(v)
      }
    end)
  end

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
  #   [1, 55]
  #
  @spec extract_chapter_range(binary) :: [binary]
  defp extract_chapter_range(raw_string) do
    raw_string
    |> captures(~r/Chapters (\w+)-(\w+)/u)
  end

  #
  # Clean up a string like:
  #   "Volume : 01 - Courts, Oregon Rules of Civil Procedure - Chapters 1-55 (48)"
  # to:
  #   ["1", "55"]
  #
  #   "Title Number : 5. Small Claims Department of Circuit Court - Chapter 46 (1)"
  # to:
  #   ["46", "46"]
  #
  @spec extract_chapter_range_from_title(binary) :: [binary]
  defp extract_chapter_range_from_title(raw_string) do
    chapters = extract_chapter_range(raw_string)

    if chapters != nil do
      chapters
    else
      chapter_number =
        raw_string
        |> capture(~r/Chapter (\w+)/u)

      [chapter_number, chapter_number]
    end
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
  # Convert a raw Title heading like:
  #   "Title Number : 57. Utility Regulation - Chapters 756-774 (16)"
  # to:
  #   "Utility Regulation"
  #
  @spec extract_title_name(binary) :: binary
  defp extract_title_name(raw_string) do
    raw_string
    |> capture(~r/\. (.+) - Chapter/)
  end

  #
  # Clean up a string like:
  #   "Volume : 01 - Courts, Oregon Rules of Civil Procedure - Chapters 1-55 (48)"
  # to:
  #   1
  #
  @spec extract_volume_number(binary) :: binary
  defp extract_volume_number(raw_string) do
    raw_string
    |> capture(~r/Volume : (\d+)/u)
    |> to_integer
    |> Integer.to_string()
  end

  #
  # Clean up a string like:
  #   "Title Number : 57. Utility Regulation - Chapters 756-774 (16)"
  # to:
  #   "57"
  #
  @spec extract_title_number(binary) :: binary
  defp extract_title_number(raw_string) do
    raw_string
    |> capture(~r/^Title Number : (\w+)\./u)
  end

  def parse(html) when is_binary(html) do
    document = Floki.parse_document!(html)

    volumes = volumes(document)
    titles = titles(document)

    results = volumes ++ titles

    %Elixir.Crawly.ParsedItem{items: results, requests: []}
  end

  def parse(%{body: html}), do: parse(html)

  # defp id(elem) do
  #   elem
  #   |> Floki.attribute("id")
  #   |> List.first("")
  # end
end
