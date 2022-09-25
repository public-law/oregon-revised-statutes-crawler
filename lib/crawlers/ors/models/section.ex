defmodule Crawlers.ORS.Models.Section do
  @moduledoc """
  An ORS Section.
  """
  use TypedStruct

  typedstruct enforce: true do
    @typedoc "An ORS Section"

    field :kind, String.t(), default: "section"
    field :name, String.t()
    field :number, String.t()
    field :chapter_number, String.t()
  end
end
