defmodule News.DateModified do
  @moduledoc """
  An article's updated-at date.
  """

  @doc "Parses the most recent Published Date from a news article."
  @spec parse(Floki.html_tree | binary) :: Date.t | nil
  def parse(document) when is_binary(document), do: Floki.parse_document!(document) |> parse

  def parse(document) do
    with [{_, _, schema_text}] <- Floki.find(document, "script[type='application/ld+json']"),
         {:ok, schema_org}     <- Jason.decode(schema_text),
         date                  <- date_modified(schema_org),
         false                 <- is_nil(date) do
      date
    else
      _ -> parse_from_meta_tags(document)
    end
  end


  @spec date_modified(any) :: Date.t | nil
  def date_modified(%{"dateModified" => date}),  do: parse_date_text(date)
  def date_modified(%{"datePublished" => date}), do: parse_date_text(date)

  def date_modified(%{"@graph" => yoast_graph}) do
    yoast_graph
    |> Enum.map(&date_modified/1)
    |> Enum.reject(&is_nil/1)
    |> List.first()
  end

  def date_modified(_), do: nil


  @spec parse_from_meta_tags(Floki.html_tree) :: Date.t | nil
  def parse_from_meta_tags(document) do
    document
    |> Floki.find("meta[property='article:published_time']")
    |> Floki.attribute("content")
    |> List.first()
    |> parse_date_text()
  end


  @spec parse_date_text(binary) :: Date.t | nil
  def parse_date_text(a_string) when is_binary(a_string) do
    with [match | _] <- Regex.run(~r/(\d{4}-\d{2}-\d{2})/, a_string),
         true        <- is_binary(match),
         {:ok, date} <- Date.from_iso8601(match) do
      date
    else
      _ -> nil
    end
  end

  def parse_date_text(_), do: nil
end
