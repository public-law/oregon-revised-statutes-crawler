require Logger


defmodule AnalyzePdfs do
  def analyze_all do
    {:ok, urls} = File.read("tmp/urls.txt")

    urls
    |> String.replace("\"", "")
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(String.length(&1) == 0))
    |> Enum.map(&parse_to_structure/1)
    |> Enum.map(&Jason.encode!/1)
    |> File.write("tmp/metadata.json")
  end


  def parse_to_structure(url) when is_binary(url) do
    case run_analyzer(url) do
      {json_text, 0} ->
        %{ source_url: url, metadata: Jason.decode!(json_text) }

      _ ->
        %{ error: url }
    end
  end


  defp run_analyzer(url) do
    IO.puts(:standard_error, "Parsing #{url}...")
    System.cmd("analyze", [url], into: "")
  end
end


AnalyzePdfs.analyze_all
