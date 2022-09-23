defmodule AllChapters do
  @moduledoc """
  First, make sure you add HTTPoison to your mix.exs dependencies:

  def deps do
    [{:httpoison, "~> 0.10.0"}]
  end
  """

  @doc """
  All Chapters
  `POST https://www.oregonlegislature.gov/bills_laws/_layouts/15/inplview.aspx?List=%7B77CEA715-9752-4B71-90C7-0417BB45D7BB%7D&View=%7BD854F19F-B98E-4414-8559-316FAEC4CA86%7D&IsXslView=TRUE&IsCSR=TRUE&IsGroupRender=TRUE`
  """
  def request do
    url = "https://www.oregonlegislature.gov/bills_laws/_layouts/15/inplview.aspx"

    # ====== Headers ======
    headers = []

    # ====== Query Params ======
    params = [
      {"List", "{77CEA715-9752-4B71-90C7-0417BB45D7BB}"},
      {"View", "{D854F19F-B98E-4414-8559-316FAEC4CA86}"},
      {"IsXslView", "TRUE"},
      {"IsCSR", "TRUE"},
      {"IsGroupRender", "TRUE"}
    ]

    # ====== Body ======
    body = ""

    HTTPoison.start()

    case HTTPoison.post(url, body, headers, params: params) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body

      {:error, error = %HTTPoison.Error{reason: reason}} ->
        IO.puts("Request failed: #{reason}")

        error
    end
  end
end
