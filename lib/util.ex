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


  @spec cat_oks(list, function) :: list
  @doc """
  See https://downloads.haskell.org/~ghc/6.12.2/docs/html/libraries/base-4.2.0.1/Data-Maybe.html#v%3AcatMaybes
  """
  def cat_oks(list, fun) do
    list
    |> reduce([], fn
      {:error, msg}, acc ->
        fun.(msg)
        acc

      {:ok, section}, acc ->
        [section | acc]
    end)
    |> reverse()
  end


  @spec cp1252_to_utf8(binary) :: binary
  @doc """
  Convenience wrapper for Elixir arg ordering.
  """
  def cp1252_to_utf8(text) when is_binary(text) do
    :erlyconv.to_unicode(:cp1252, text)
  end

  @spec normalize_whitespace(binary) :: binary
  def normalize_whitespace(text) when is_binary(text) do
    text
    |> convert_windows_line_endings()
    |> clean_no_break_spaces()
    |> clean_multiple_spaces()
    |> String.trim()
  end

  @doc """
  In UTF-8 character value C2 A0 (194 160) is defined as
  NO-BREAK SPACE.
  """
  @spec clean_no_break_spaces(binary) :: binary
  def clean_no_break_spaces(text) when is_binary(text) do
    String.replace(text, <<194, 160>>, " ")
  end

  @spec convert_windows_line_endings(binary) :: binary
  def convert_windows_line_endings(text) when is_binary(text) do
    String.replace(text, "\r\n", "\n")
  end

  @spec clean_multiple_spaces(binary) :: binary
  def clean_multiple_spaces(text) when is_binary(text) do
    String.replace(text, ~r/\s+/, " ")
  end
end
