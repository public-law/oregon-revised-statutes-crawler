defmodule Crawlers.String do
  @moduledoc """
  Extensions to String.
  """

  @spec capture(binary, Regex.t()) :: binary | nil
  def capture(string, regex) do
    captures(string, regex) |> Enum.at(0)
  end


  @spec captures(binary, Regex.t()) :: [binary] | nil
  def captures(string, regex) do
    Regex.run(regex, string, capture: :all_but_first)
  end


  @spec blank?(binary) :: boolean()
  def blank?(s) do
    empty?(s) || String.match?(s, ~r/^\s+$/)
  end


  @spec empty?(binary) :: boolean()
  def empty?(s) do
    String.length(s) == 0
  end
end
