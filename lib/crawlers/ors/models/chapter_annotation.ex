defmodule Crawlers.ORS.Models.ChapterAnnotation do
  @moduledoc """
  An annotation on a chapter.
  """
  use TypedStruct
  use Domo, skip_defaults: true

  import Crawlers.String


  typedstruct enforce: true do
    @typedoc "An ORS Annotation for a Chapter"

    field :kind, String.t(), default: "chapter annotation"
    field :heading, String.t()
    field :text, String.t()
    field :chapter_number, String.t()
  end

  precond t: &validate_struct/1

  defp validate_struct(struct) do
    cond do
      empty?(struct.name) ->
        {:error, "Name can't be blank."}

      !(struct.number =~ ~r/^[[:alnum:]]{1,4}\.[[:alnum:]]{3,4}$/) ->
        {:error, "Malformed number: \"#{struct.number}\""}

      true ->
        :ok
    end
  end

end
