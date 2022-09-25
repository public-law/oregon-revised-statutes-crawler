ExUnit.start()

defmodule TestHelper do
  @moduledoc """
  Convenient functions for test writing.
  """

  @fixture_dir "test/fixtures"

  @doc """
  Return the contents of a file in test/fixtures.

  E.g.:
      fixture_file("ors838.html", cp1252: true)
  """
  def fixture_file(path, opts \\ [])

  def fixture_file(path, cp1252: true) do
    fixture_file(path)
    |> cp1252_to_utf8
  end

  def fixture_file(path, _opts) do
    (@fixture_dir <> "/" <> path)
    |> File.read!()
  end

  @doc """
  Convenience wrapper for Elixir arg ordering.
  """
  def cp1252_to_utf8(text) do
    :erlyconv.to_unicode(:cp1252, text)
  end
end
