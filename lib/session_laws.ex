defmodule SessionLaws do
  @moduledoc """
  Session laws API client.

  Source Index: https://www.oregonlegislature.gov/bills_laws/Pages/Oregon-Laws.aspx
  """

  @url "https://www.oregonlegislature.gov/bills_laws/_layouts/15/inplview.aspx"


  @spec special_session_pdfs(integer, integer) :: list | HTTPoison.Error.t()
  def special_session_pdfs(year, session_number) when is_integer(session_number) do
    pdf_paths(year, "Special #{session_number}")
  end


  @spec regular_session_pdfs(integer) :: list | HTTPoison.Error.t()
  def regular_session_pdfs(year) do
    pdf_paths(year, "Regular")
  end


  @spec pdf_paths(integer, binary) :: list | HTTPoison.Error.t()
  # @doc """
  # E.g.,
  #   `SessionLaws.pdf_paths(2021, "Special 2")`
  #   `SessionLaws.pdf_paths(2022, "Regular")`
  # """
  defp pdf_paths(year, session) when is_integer(year) and is_binary(session) do
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
    case HTTPoison.post(@url, body, headers, params: params) do
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
