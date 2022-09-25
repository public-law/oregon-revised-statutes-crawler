ExUnit.start()

defmodule TestHelper do
  @moduledoc """
  Convenient functions for test writing.
  """

  @doc """
  Return the contents of a file in test/fixtures.
  """
  def fixture_file(path) do
    "test/fixtures/#{path}"
    |> File.read!()
  end

  @doc """
  Convenience wrapper for Elixir arg ordering.
  """
  def cp1252_to_utf8(text) do
    :erlyconv.to_unicode(:cp1252, text)
  end
end
