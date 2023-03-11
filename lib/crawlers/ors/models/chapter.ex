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
        {:error, "Name can't be blank."}

      empty?(struct.url) ->
        {:error, "URL can't be blank."}

      empty?(struct.anno_url) ->
        {:error, "Annotation URL can't be blank."}

      struct.name == "(Former Provisions)" ->
        {:error, "Former Provisions chapters are not valid."}

      invalid_chapter_number?(struct.number) ->
        {:error, "Malformed chapter number: \"#{struct.number}\""}

      true ->
        :ok
    end
  end


  def invalid_chapter_number?(n) when is_bitstring(n) do
    !(n =~ ~r/^[[:alnum:]]{1,4}$/)
  end

end
