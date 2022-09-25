import Enum

defmodule Util do
  @moduledoc """
  Utility functions.
  """
  def group_until(list, predicate) do
    reduce(list, [], fn e, acc ->
      case predicate.(e) do
        true ->
          [[e]] ++ acc

        false ->
          {curr, rest} = List.pop_at(acc, 0)

          case curr do
            nil -> acc
            _ -> [curr ++ [e] | rest]
          end
      end
    end)
  end
end
