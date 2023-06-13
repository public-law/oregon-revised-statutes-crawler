defmodule Html do
  @moduledoc """
  Utilities for working with Floki HTML nodes.
  """

  @spec text_in(Floki.html_tree) :: binary
  def text_in(node) do
    node
    |> Floki.text()
    |> Util.replace_rn()
    |> String.trim()
  end
end
