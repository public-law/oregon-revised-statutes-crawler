require Logger


defmodule AnalyzePdfs do
  def analyze_all do
    {:ok, urls} = File.read("tmp/urls.txt")

    urls
    |> String.replace("\"", "")
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(String.length(&1) == 0))
    |> Enum.map(&parse_to_json/1)
    |> Enum.map(&Jason.encode!/1)
    |> Enum.map(&IO.puts/1)
  end


  def parse_to_json(url) do
    IO.puts(:standard_error, "Parsing #{url}...")

    json_text = case System.cmd("analyze", [url], into: "") do
      {json_text, 0} ->
        json_text

      _ ->
        "{ \"error\": \"#{url}\" }"
    end

    Jason.decode!(json_text)
  end
end


AnalyzePdfs.analyze_all
