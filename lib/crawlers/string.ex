defmodule Crawlers.String do
  @moduledoc """
  Extensions to String.
  """

  @spec capture(binary, Regex.t()) :: binary | nil
  def capture(string, regex) when is_binary(string) do
    list_of_captures = captures(string, regex)

    if list_of_captures == nil do
      nil
    else
      hd(list_of_captures)
    end
  end


  @spec capture(binary, Regex.t()) :: binary | nil
  def capture_last(string, regex) when is_binary(string) do
    list_of_captures = Regex.scan(regex, string, capture: :all_but_first)

    if Enum.empty?(list_of_captures) do
      nil
    else
      List.last(list_of_captures)
    end
  end


  @spec captures(binary, Regex.t()) :: [binary] | nil
  def captures(string, regex) when is_binary(string) do
    Regex.run(regex, string, capture: :all_but_first)
  end


  @spec blank?(binary) :: boolean()
  def blank?(s) when is_binary(s) do
    empty?(s) || String.match?(s, ~r/^\s+$/)
  end


  @spec empty?(binary) :: boolean()
  def empty?(s) when is_binary(s) do
    String.length(s) == 0
  end
end
