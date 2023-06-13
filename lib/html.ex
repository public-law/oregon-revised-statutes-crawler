defmodule Html do
  @moduledoc """
  Utilities for working with Floki HTML nodes.
  """

  @spec text_in(Floki.html_tree) :: binary
  def text_in(node) do
    node
    |> Floki.text()
    |> replace_rn()
    |> String.trim()
  end

  @spec replace_rn(binary) :: binary
  def replace_rn(text) do
    text
    |> String.replace("\r\n", " ")
    |> String.replace("\n", " ")
  end
end
