import Enum

defmodule Util do
  @moduledoc """
  Utility functions.
  """

  @spec group_with(list, function) :: list
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
    reduce(list, [], group_with_func(predicate)) |> reverse
  end

  defp group_with_func(predicate) do
    fn e, acc ->
      if predicate.(e) do
        [[e]] ++ acc
      else
        case acc do
          [curr | tail] -> [curr ++ [e] | tail]
          [] -> []
        end
      end
    end
  end


  @spec cat_oks(list, function) :: list
  @doc """
  Takes a list of `:ok|:error` and returns a list of all the `:ok` values. Invokes
  the given function on each error message.
  See https://downloads.haskell.org/~ghc/6.12.2/docs/html/libraries/base-4.2.0.1/Data-Maybe.html#v%3AcatMaybes
  """
  def cat_oks(list, fun) do
    list
    |> Enum.flat_map(fn
      {:ok, result} -> [result]
      {:error, msg} ->
        fun.(msg)
        []
    end)
  end


  def node_has_text?(node, text) do
    node
    |> Floki.text()
    |> String.contains?(text)
  end


  @spec convert_from_windows_text(binary) :: binary
  def convert_from_windows_text(text) do
    text
    |> Util.cp1252_to_utf8()
    |> Util.convert_windows_line_endings()
    |> Util.clean_no_break_spaces()
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
  @doc """
  iex> convert_windows_line_endings("line 1\\r\\nline 2")
  "line 1\\nline 2"
  """
  def convert_windows_line_endings(text) when is_binary(text) do
    String.replace(text, "\r\n", "\n")
  end


  @spec remove_newlines(binary) :: binary
  @doc """
  iex> remove_newlines("a\\nb\\nc")
  "a b c"

  iex> remove_newlines("a \\nb")
  "a b"
  """
  def remove_newlines(text) do
    text
    |> String.replace("\n", " ")
    |> clean_multiple_spaces()
  end


  @spec clean_multiple_spaces(binary) :: binary
  @doc """
  iex> clean_multiple_spaces("a  b         c")
  "a b c"

  iex> clean_multiple_spaces("abc")
  "abc"
  """
  def clean_multiple_spaces(text) when is_binary(text) do
    String.replace(text, ~r/\s+/, " ")
  end


  @spec remove_trailing_period(binary) :: binary
  @doc """
  iex> remove_trailing_period("Hello.")
  "Hello"

  iex> remove_trailing_period("Hello")
  "Hello"
  """
  def remove_trailing_period(text) when is_binary(text) do
    String.replace(text, ~r/\.$/, "")
  end
end
