defmodule Crawlers.ORS.Models.SectionAnnotation do
  @moduledoc """
  An annotation on a section.
  """
  use TypedStruct
  use Domo, skip_defaults: true

  import Crawlers.String
  import Crawlers.ORS.Models.Section, only: [invalid_section_number?: 1]

  typedstruct enforce: true do
    @typedoc "An ORS Annotation for a Section"

    field :kind, String.t(), default: "section annotation"
    field :heading, String.t()
    field :text, String.t()
    field :section_number, String.t()
  end

  precond t: &validate_struct/1

  defp validate_struct(struct) do
    cond do
      empty?(struct.heading) ->
        {:error, "Heading can't be blank."}

      empty?(struct.text) ->
        {:error, "Text can't be blank."}

      invalid_section_number?(struct.section_number) ->
        {:error, "Malformed number: \"#{struct.section_number}\""}

      true ->
        :ok
    end
  end
end
