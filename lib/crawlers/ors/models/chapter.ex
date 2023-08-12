defmodule Crawlers.ORS.Models.Chapter do
  @moduledoc """
  An ORS Chapter.
  """
  use TypedStruct
  use Domo, skip_defaults: true
  import Crawlers.String

  typedstruct enforce: true do
    @typedoc "An ORS Chapter"

    field :kind, String.t(), default: "chapter"
    field :name, String.t()
    field :number, String.t()
    field :title_number, String.t()
    field :url, String.t()
    field :anno_url, String.t()
  end


  precond t: &validate_struct/1

  defp validate_struct(struct) do
    cond do
      empty?(struct.name) ->
        {:error, "Ch. #{struct.number}: Name can't be blank."}

      empty?(struct.url) ->
        {:error, "Ch. #{struct.number}: URL can't be blank."}

      empty?(struct.anno_url) ->
        {:error, "Ch. #{struct.number}: Annotation URL can't be blank."}

      invalid_chapter_number?(struct.number) ->
        {:error, "Ch. ...: Malformed chapter number: '#{struct.number}'"}

      true ->
        :ok
    end
  end


  def invalid_chapter_number?(n) when is_bitstring(n) do
    !(n =~ ~r/^[[:alnum:]]{1,4}$/)
  end
end
