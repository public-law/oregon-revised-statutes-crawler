import Enum

defmodule Util do
  @moduledoc """
  Utility functions.
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
              _ -> [curr ++ [e] | rest]
            end
        end
      end)

    reverse(result_reversed)
  end
end
