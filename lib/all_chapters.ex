defmodule AllChapters do
  @moduledoc """
  ORS API client.
  """

  @doc """
  All Chapters

  `POST https://www.oregonlegislature.gov/bills_laws/_layouts/15/inplview.aspx?List=%7B77CEA715-9752-4B71-90C7-0417BB45D7BB%7D&View=%7BD854F19F-B98E-4414-8559-316FAEC4CA86%7D&IsXslView=TRUE&IsCSR=TRUE&IsGroupRender=TRUE`

  See: https://learn.microsoft.com/en-us/sharepoint/dev/sp-add-ins/working-with-lists-and-list-items-with-rest
  """
  def request do
    url = "https://www.oregonlegislature.gov/bills_laws/_layouts/15/inplview.aspx"

    # ====== Headers ======
    headers = []

    # ====== Query Params ======
    params = [
      {"List", "{77CEA715-9752-4B71-90C7-0417BB45D7BB}"},
      {"View", "{D854F19F-B98E-4414-8559-316FAEC4CA86}"}, # Specifies the base view that will be used to render the list.
      {"IsXslView", "TRUE"},      # XSLT list view
      {"IsCSR", "TRUE"},          # Client Side Rendering
      {"IsGroupRender", "TRUE"}   # Grouping
    ]

    # ====== Body ======
    body = ""

    HTTPoison.start()

    case HTTPoison.post(url, body, headers, params: params) do
      {:ok, %{status_code: 200, body: body}} ->
        Jason.decode!(body)["Row"]

      {:error, error = %HTTPoison.Error{reason: reason}} ->
        IO.puts("Request failed: #{reason}")

        error
    end
  end
end
