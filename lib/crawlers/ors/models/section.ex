defmodule Crawlers.ORS.Models.Section do
  @moduledoc """
  An ORS Section.
  """
  use TypedStruct
  use Domo, skip_defaults: true

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
      String.length(struct.name) == 0 ->
        {:error, "Name can't be blank."}

      !(struct.number =~ ~r/^[[:alnum:]]{1,4}\.[[:alnum:]]{3,4}$/) ->
        {:error, "Malformed number: \"#{struct.number}\""}

      true ->
        :ok
    end
  end

end
