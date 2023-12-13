import Enum
import List

alias News.Http
alias News.DateModified
alias News.Leginfo
alias News.Parser
alias News.PublicLaw


defmodule News.Article do
  @moduledoc "The main entity being parsed."

  @enforce_keys [
    :citations,
    :title,
    :description,
    :source_name,
    :source_url,
    :date_modified
  ]
  @derive Jason.Encoder
  defstruct [
    :citations,
    :title,
    :description,
    :source_name,
    :source_url,
    :date_modified
  ]


  @doc """
  Find citations in a string of HTML or from a URL.
  """
  def parse(url) when is_binary(url) do
    parse(URI.parse(url))
  end

  def parse(%URI{} = uri) do
    url       = URI.to_string(uri)
    temp_file = News.File.tmp_file!(url)
    File.write!(temp_file, Http.get!(url))

    parse_from_file(temp_file, uri)
  end


  def parse_from_file(path, uri) do
    html = case Path.extname(path) do
      ".pdf" -> News.File.read_pdf_as_html!(path)
      _      -> File.read!(path)
    end

    parse_from_html(html, uri)
  end


  def parse_from_html(html, uri) do
    {:ok, document} = Floki.parse_document(html)

    cites      = find_citations_in_html(document)
    title      = Parser.find_title(document)
    descr      = find_description_in_html(document)
    source     = Parser.find_source_name(document, uri)
    source_url = Parser.find_source_url(uri)
    date       = DateModified.parse(document)

    %News.Article{
      citations: cites,
      title: title,
      description: descr,
      source_name: source,
      source_url: source_url,
      date_modified: date
    }
  end


  def find_citations_in_html(document) do
    cites_from_hrefs =
      document
      |> hrefs()
      |> map(&href_to_cite/1)

    html = Floki.text(document)
    crs_cites_from_text_1 =
      Regex.scan(~r/(C.R.S. &#xa7;(?:&#xa7;)? \d+-\d+-\d+)/, html)
      |> flatten()
      |> map(fn m -> String.replace(m, ~r/&#xa7; ?/, "", global: true) end)

    crs_cites_from_text_2 =
      Regex.scan(~r/(\d+-\d+-\d+(?:\.\d+)?) C.R.S./, html)
      |> map(&last/1)
      |> map(fn m -> "C.R.S. #{m}" end)
      |> flatten()

    tx_cites_from_text =
      Regex.scan(~r/(Texas \w+ Code Section [\d\w.]+)/, html)
      |> flatten()
      |> map(fn m -> String.replace(m, "Texas ",          "Tex. ")    end)
      |> map(fn m -> String.replace(m, "Family ",         "Fam. ")    end)
      |> map(fn m -> String.replace(m, "Transportation ", "Transp. ") end)


     (cites_from_hrefs ++ crs_cites_from_text_1 ++ crs_cites_from_text_2 ++ tx_cites_from_text)
     |> filter(&is_binary/1)
     |> cleanup_list()
  end


  def hrefs(document) do
    document
    |> Floki.attribute("a", "href")
    |> flatten()
    |> map(&URI.parse/1)
    |> reject(&is_nil/1)
  end


  @spec href_to_cite(URI.t) :: nil | binary
  def href_to_cite(%URI{} = url) do
    cond do
      Http.tld(url) == "public.law" ->
        PublicLaw.url_to_cite(url)

      url.host == "leginfo.legislature.ca.gov" ->
        Leginfo.url_to_cite(url)

      true -> nil
    end
  end


  @spec cleanup_list(list) :: list
  defp cleanup_list(list) do
    list
    |> sort()
    |> uniq()
  end


  # Retrieve the HTML description meta tag's content.
  # <meta name="description" content="Questions and answers regarding charter school staffing issues." />
  defp find_description_in_html(document) do
    document
    |> Floki.find("meta[name=description]")
    |> Floki.attribute("content")
    |> Floki.text()
    |> String.trim()
  end
end
