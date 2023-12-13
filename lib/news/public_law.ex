defmodule News.PublicLaw do
  @moduledoc """
  Support for the Public.Law website.
  """

  @doc """
    Examples:
      iex> News.PublicLaw.url_to_cite(URI.parse "https://oregon.public.law/statutes/ors_336.029")
      "ORS 336.029"
  
  """
  @spec url_to_cite(URI.t) :: binary
  def url_to_cite(%URI{path: path}) do
    path
    |> String.split("/")
    |> List.last
    |> String.replace("_", " ")
    |> News.Text.titleize
  end
end
