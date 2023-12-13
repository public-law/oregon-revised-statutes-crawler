alias News.CalCodes

defmodule News.Leginfo do
  @moduledoc false

  @spec url_to_cite(URI.t()) :: nil | binary()
  def url_to_cite(%URI{query: query}) do
    query
    |> URI.decode_query()
    |> make_cite_to_cal_codes()
  end


  defp make_cite_to_cal_codes(%{"lawCode" => code, "sectionNum" => section}) do
    "CA #{CalCodes.code_to_abbrev(code)} Section #{section}"
    |> String.replace_suffix(".", "")
  end

  defp make_cite_to_cal_codes(_), do: nil
end
