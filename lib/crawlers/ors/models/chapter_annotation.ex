defmodule Crawlers.ORS.Models.ChapterAnnotation do
  @moduledoc """
  An annotation on a chapter.
  """
  use TypedStruct
  use Domo, skip_defaults: true

  import Crawlers.String
  import Crawlers.ORS.Models.Chapter, only: [invalid_chapter_number?: 1]


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
      empty?(struct.heading) ->
        {:error, "Heading can't be blank."}

      empty?(struct.text) ->
        {:error, "Text can't be blank."}

      invalid_chapter_number?(struct.number) ->
        {:error, "Malformed number: \"#{struct.chapter_number}\""}

      true ->
        :ok
    end
  end

end
