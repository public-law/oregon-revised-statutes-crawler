defmodule LawPdfs do
  @moduledoc """
  Session laws API client.
  """

  @spec request :: list | HTTPoison.Error.t()
  @doc """
  # Request
  # POST https://www.oregonlegislature.gov/bills_laws/_layouts/15/inplview.aspx?List=%7B88BF04C7-3C52-4FFA-9717-94016EC3B24E%7D&View=%7B3BEB1821-2C16-4437-85F5-00046A0A96E7%7D&IsXslView=TRUE&IsCSR=TRUE&GroupString=%3B%232022%20Regular%3B%23&IsGroupRender=TRUE
  """
  def request() do
    url = "https://www.oregonlegislature.gov/bills_laws/_layouts/15/inplview.aspx"

    # ====== Headers ======
    headers = []

    # ====== Query Params ======
    params = [
      {"List", "{88BF04C7-3C52-4FFA-9717-94016EC3B24E}"},
      {"View", "{3BEB1821-2C16-4437-85F5-00046A0A96E7}"},
      {"IsXslView", "TRUE"},
      {"IsCSR", "TRUE"},
      {"GroupString", ";#2022 Regular;#"},
      {"IsGroupRender", "TRUE"},
    ]

    # ====== Body ======
    body = ""

    HTTPoison.start()
    case HTTPoison.post(url, body, headers, params: params) do
      {:ok, _response = %HTTPoison.Response{status_code: _status_code, body: body}} ->
        Jason.decode!(body)
        |> Map.get("Row")
        |> Enum.map(fn item -> item["TitleURL"] end)

      {:error, error = %HTTPoison.Error{reason: reason}} ->
        IO.puts("Request failed: #{reason}")

        error
    end
  end
end
