defmodule Crawlers.ORS.Models.SectionAnnotation do
  @moduledoc """
  An annotation on a section.
  """
  use TypedStruct
  use Domo, skip_defaults: true

  typedstruct enforce: true do
    @typedoc "An ORS Annotation Record"

    field :kind, String.t(), default: "section annotation"
    field :section_number, String.t()
    field :text_blocks, [String.t()]
  end

  precond t: &validate_struct/1

  defp validate_struct(struct) do
    cond do
      Enum.empty?(struct.text_blocks) ->
        {:error, "Text can't be blank."}

      !section_heading?(struct.section_number) ->
        {:error, "Malformed heading: \"#{struct.section_number}\""}

      true ->
        :ok
    end
  end

  @doc """
    Examples:
      "      2.570"
      "      2.570 to 2.580"
  """
  @spec section_heading?(binary) :: boolean
  def section_heading?(paragraph) when is_binary(paragraph) do
    paragraph
    |> Util.convert_windows_line_endings()
    # |> Util.normalize_whitespace()
    |> String.match?(~r/^\w+\.\w+(\sto\s\w+\.\w+)?$/)
  end
end
