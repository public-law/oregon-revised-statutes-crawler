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
          acc
      end
    end)
  end
end
