defmodule Crawlers.ORS.Models.Chapter do
  @moduledoc """
  An ORS Chapter.
  """
  use TypedStruct

  typedstruct enforce: true do
    @typedoc "An ORS Chapter"

    field :kind, String.t(), default: "chapter"
    field :name, String.t()
    field :number, String.t()
    field :title_number, String.t()
    field :url, String.t()
  end
end
