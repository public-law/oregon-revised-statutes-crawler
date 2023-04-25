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
    field :edition, integer()
  end

  precond t: &validate_struct/1

  defp validate_struct(struct) do
    cond do
      empty?(struct.name) ->
        {:error, "§ #{struct.number}: Name can't be blank."}

      empty?(struct.text) ->
        {:error, "§ #{struct.number}: Text can't be blank."}

      invalid_section_number?(struct.number) ->
        {:error, "§ ...: Malformed number: '#{struct.number}' in #{inspect(struct)}"}

      true ->
        :ok
    end
  end

  def invalid_section_number?(n) when is_bitstring(n) do
    !(n =~ ~r/^[[:alnum:]]{1,4}\.[[:alnum:]]{3,4}$/)
  end
end
