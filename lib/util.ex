import Enum

defmodule Util do
  @moduledoc """
  Utility functions.
  """

  @doc """
  Group a list of elements into sub-lists, where each sub-list is
  led by an element that satisfies the predicate. It skips initial
  elements that do not satisfy the predicate.

  iex> group_with([1, 2, 3, 1, 4], &(&1 == 1))
  [[1, 2, 3], [1, 4]]

  iex> group_with(["a", "b", "x", "c", "d"], &(&1 == "x"))
  [["x", "c", "d"]]
  """
  def group_with(list, predicate) do
    result_reversed =
      reduce(list, [], fn e, acc ->
        case predicate.(e) do
          true ->
            [[e]] ++ acc

          false ->
            case acc do
              [curr | tail] -> [curr ++ [e] | tail]
              [] -> []
            end
        end
      end)

    reverse(result_reversed)
  end

  @doc """
  Convenience wrapper for Elixir arg ordering.
  """
  def cp1252_to_utf8(text) do
    :erlyconv.to_unicode(:cp1252, text)
  end

  @doc """
  In UTF-8 character value C2 A0 (194 160) is defined as
  NO-BREAK SPACE.
  """
  @spec clean_no_break_spaces(binary) :: binary
  def clean_no_break_spaces(text) do
    String.replace(text, <<194, 160>>, " ")
  end

  @spec convert_windows_line_endings(binary) :: binary
  def convert_windows_line_endings(text) do
    String.replace(text, "\r\n", "\n")
  end
end
