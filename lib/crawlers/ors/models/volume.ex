defmodule Crawlers.ORS.Models.Volume do
  @moduledoc """
  An ORS Volume.
  """
  use TypedStruct

  typedstruct enforce: true do
    @typedoc "An ORS Volume"

    field :kind, String.t(), default: "volume"
    field :name, String.t()
    field :number, String.t()
    field :chapter_range, [String.t()]
  end
end
