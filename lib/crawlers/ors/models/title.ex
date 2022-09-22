defmodule Crawlers.ORS.Models.Title do
  @moduledoc """
  An ORS Title.
  """
  use TypedStruct

  typedstruct enforce: true do
    @typedoc "An ORS Title"

    field :kind, String.t(), default: "title"
    field :name, String.t()
    field :number, String.t()
    # field :chapter_range, [pos_integer]
  end
end
