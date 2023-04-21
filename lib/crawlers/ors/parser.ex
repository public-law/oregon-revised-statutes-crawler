import Enum, only: [at: 2, filter: 2, map: 2, uniq: 1]
import String, except: [at: 2, filter: 2]
require Logger

alias Crawlers.ORS.Models.Volume
alias Crawlers.ORS.Models.Title
alias Crawlers.ORS.Models.Chapter
import Crawlers.String, only: [capture: 2, captures: 2]


defmodule Parser do
  @moduledoc """
  The Parser module is responsible for converting the response from the spider.
  """

  @spec parse_home_page(
          binary
          | %{
              :body => binary | %{:body => binary | map, optional(any) => any},
              optional(any) => any
            }
        ) :: Crawly.ParsedItem.t()
  def parse_home_page(%{body: html}), do: parse_home_page(html)

  def parse_home_page(html) when is_bitstring(html) do
    document = Floki.parse_document!(html)

    volumes  = volumes(document)
    titles   = titles(document)
    chapters = chapters(AllChapters.request())

    chapter_reqs =
      chapters
      |> map(fn c -> c.url end)
      |> Enum.reverse()
      |> map(&Crawly.Utils.request_from_url/1)

    anno_reqs =
      chapters
      |> map(fn c -> c.anno_url end)
      |> Enum.reverse()
      |> map(&Crawly.Utils.request_from_url/1)

    %Elixir.Crawly.ParsedItem{
      items: volumes ++ titles ++ chapters,
      requests: chapter_reqs ++ anno_reqs
    }
  end


  @spec chapters(any) :: [Chapter]
  def chapters(api_data) do
    parse_results =
      api_data
      |> map(fn c ->
        url = "https://www.oregonlegislature.gov" <> Map.fetch!(c, "TitleURL")

        Chapter.new(
          name: Map.fetch!(c, "ORS_x0020_Chapter_x0020_Title"),
          number: Map.fetch!(c, "Title") |> capture(~r/Chapter (\w+)/) |> trim_leading("0"),
          title_number: Map.fetch!(c, "ORS_x0020_Chapter") |> capture(~r/^([^.]+)/),
          url: url,
          anno_url: replace(url, "ors/ors", "ors/ano")
        )
      end)

    Util.cat_oks(parse_results, &Logger.info/1)
  end


  @spec titles(Floki.html_tree()) :: [Title.t()]
  def titles(document) do
    document
    |> extract_headings()
    |> filter(&String.match?(&1.text, ~r/Title/))
    |> map(fn title_heading ->
      %Title{
        name: extract_title_name(title_heading.text),
        number: extract_title_number(title_heading.text),
        chapter_range: extract_chapter_range_from_title(title_heading.text),
        volume_number: capture(title_heading.id, ~r/-([^_]+)_/)
      }
    end)
  end

  @spec volumes(Floki.html_tree()) :: [Volume.t()]
  def volumes(document) do
    document
    |> extract_headings()
    |> map(& &1.text)
    |> uniq
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
  @spec extract_headings(Floki.html_tree()) :: list(%{})
  defp extract_headings(document) do
    document
    |> Floki.find("tbody[id^=titl]")
    |> map(fn e ->
      %{
        id: id(e),
        text: trim(Floki.text(e))
      }
    end)
  end

  #
  # Extract the chapter range numbers from a Volume heading like this:
  #   "Volume : 01 - Courts, Oregon Rules of Civil Procedure - Chapters 1-55 (48)"
  #
  # to:
  #   [1, 55]
  #
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
    |> trim_leading("0")
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

  defp id(elem) do
    elem
    |> Floki.attribute("id")
    |> List.first("")
  end
end
