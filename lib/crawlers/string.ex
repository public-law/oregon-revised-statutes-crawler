defmodule Crawlers.String do
  @moduledoc """
  Extensions to String.
  """

  @spec capture(binary, Regex.t()) :: nil | binary
  def capture(string, regex) do
    captures(string, regex) |> Enum.at(0)
  end

  @spec captures(binary, Regex.t()) :: [binary]
  def captures(string, regex) do
    Regex.run(regex, string, capture: :all_but_first)
  end
end
