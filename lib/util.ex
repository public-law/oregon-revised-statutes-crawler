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
            # Start a new group.
            [[e]] ++ acc

          false ->
            # Try to extract the current group.
            {curr, rest} = List.pop_at(acc, 0)

            case curr do
              # Skip until predicate is true.
              nil -> acc
              # Append to current group.
              group -> [group ++ [e] | rest]
            end
        end
      end)

    reverse(result_reversed)
  end
end
