import Enum

defmodule News.Text do
  @moduledoc """
  A module for text functions.
  """

  @spec titleize(binary) :: binary
  def titleize(string) when is_binary(string) do
    string
    |> String.split(" ")
    |> map(&String.capitalize/1)
    |> join(" ")
    |> String.replace("N.y.", "N.Y.")
    |> String.replace("Ors",  "ORS")
    |> String.replace(~r/^Ca /,  "CA ")
  end
end
