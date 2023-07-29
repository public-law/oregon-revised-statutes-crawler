defmodule SessionLaws do
  @moduledoc """
  Session laws API client.
  """

  @spec pdf_paths(integer, binary) :: list | HTTPoison.Error.t()
  @doc """
  E.g.,
    `SessionLaws.pdf_paths(2021, "Special 2")`
    `SessionLaws.pdf_paths(2022, "Regular")`
  """
  def pdf_paths(year, session) when is_integer(year) and is_binary(session) do
    url = "https://www.oregonlegislature.gov/bills_laws/_layouts/15/inplview.aspx"

    # ====== Headers ======
    headers = []

    # ====== Query Params ======
    params = [
      {"List",          "{88BF04C7-3C52-4FFA-9717-94016EC3B24E}"},
      {"View",          "{3BEB1821-2C16-4437-85F5-00046A0A96E7}"},
      {"IsXslView",     "TRUE"},
      {"IsCSR",         "TRUE"},
      {"GroupString",   ";##{year} #{session};#"},
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
