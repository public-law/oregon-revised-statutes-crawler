defmodule Crawlers.Regex do
  @moduledoc """
  Extensions to Regex.
  """

  @spec capture(binary, Regex.t()) :: nil | binary
  def capture(string, regex) do
    Regex.run(regex, string, capture: :all_but_first)
  end
end
