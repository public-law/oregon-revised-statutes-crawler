defmodule Crawlers.ORS.Models.Section do
  @moduledoc """
  An ORS Section.
  """
  use TypedStruct
  use Domo, skip_defaults: true

  import Crawlers.String

  typedstruct enforce: true do
    @typedoc "An ORS Section"

    field :kind, String.t(), default: "section"
    field :name, String.t()
    field :number, String.t()
    field :text, String.t()
    field :chapter_number, String.t()
  end

  precond t: &validate_struct/1

  defp validate_struct(struct) do
    cond do
      empty?(struct.name) ->
        {:error, "Name can't be blank (parsing #{struct.number})."}

      empty?(struct.text) ->
        {:error, "Text can't be blank (parsing #{struct.number})."}

      invalid_section_number?(struct.number) ->
        {:error, "Malformed number: \"#{struct.number}\""}

      true ->
        :ok
    end
  end

  def invalid_section_number?(n) when is_bitstring(n) do
    !(n =~ ~r/^[[:alnum:]]{1,4}\.[[:alnum:]]{3,4}$/)
  end
end
