defmodule Crawlers.ORS.Models.SectionAnnotation do
  @moduledoc """
  An annotation on a section.
  """
  use TypedStruct
  use Domo, skip_defaults: true

  import Crawlers.String
  import Parser.AnnotationFile, only: [section_heading?: 1]

  typedstruct enforce: true do
    @typedoc "An ORS Annotation Record"

    field :kind, String.t(), default: "section annotation"
    field :section_number, String.t()
    field :text, String.t()
  end

  precond t: &validate_struct/1

  defp validate_struct(struct) do
    cond do
      empty?(struct.text) ->
        {:error, "Text can't be blank."}

      !section_heading?(struct.section_number) ->
        {:error, "Malformed heading: \"#{struct.section_number}\""}

      true ->
        :ok
    end
  end
end
