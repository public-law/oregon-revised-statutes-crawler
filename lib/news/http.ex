defmodule News.Http do
  @moduledoc """
  A module for HTTP functions.
  """

  @spec tld(URI.t) :: binary | nil

  @doc """
  Get the top-level domain from a URI.

  ## Examples

      iex> News.Http.tld(%URI{host: "www.example.com"})
      "example.com"

      iex> News.Http.tld(%URI{host: "www.example.co.uk"})
      "co.uk"

      iex> News.Http.tld(%URI{host: "oregon.public.law"})
      "public.law"

  """
  def tld(%URI{host: nil}), do: nil

  def tld(%URI{host: host}) do
    host
    |> String.split(".")
    |> Enum.reverse()
    |> Enum.take(2)
    |> Enum.reverse()
    |> Enum.join(".")
  end


  @doc "Just a simple HTTP GET request."
  def get!(url), do: CurlEx.get_with_user_agent!(url, :microsoft_edge_windows)
end
