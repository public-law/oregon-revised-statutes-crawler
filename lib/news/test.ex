defmodule News.Test do
  @moduledoc """
  Test helpers.
  """


  @doc """
  Returns the parsed contents of an HTML fixture file.
  """
  @spec fixture_html!(binary) :: Floki.dom
  def fixture_html!(filename) do
    filename
    |> fixture_file!
    |> Floki.parse_document!
  end


  @doc """
  Returns the contents of a fixture file.
  """
  @spec fixture_file!(binary) :: binary
  def fixture_file!(filename) do
    filename
    |> fixture_path
    |> File.read!
  end


  @spec fixture_path(binary) :: binary
  defp fixture_path(filename) do
    Path.join("test/fixtures", filename)
  end
end
