defmodule Crawlers.ORS.Models.Section do
  @moduledoc """
  An ORS Section.
  """
  use TypedStruct
  use Domo

  typedstruct enforce: true do
    @typedoc "An ORS Section"

    field :kind, String.t(), default: "section"
    field :name, String.t(), default: ""
    field :number, String.t(), default: ""
    field :text, String.t(), default: ""
    field :chapter_number, String.t(), default: ""
  end
end
