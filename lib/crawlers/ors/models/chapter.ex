defmodule Crawlers.ORS.Models.Chapter do
  @moduledoc """
  An ORS Chapter.
  """
  use TypedStruct
  use Domo, skip_defaults: true

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
      String.length(struct.name) == 0 ->
        {:error, "Name can't be blank."}

      String.length(struct.url) == 0 ->
        {:error, "URL can't be blank."}

      String.length(struct.anno_url) == 0 ->
        {:error, "Annotation URL can't be blank."}

      struct.name == "(Former Provisions)" ->
        {:error, "Former Provisions chapters are not valid."}

      !(struct.number =~ ~r/^[[:alnum:]]{1,4}$/) ->
        {:error, "Malformed number: \"#{struct.number}\""}

      true ->
        :ok
    end
  end

end
