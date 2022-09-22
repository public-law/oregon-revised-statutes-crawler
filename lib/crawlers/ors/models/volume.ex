defmodule Crawlers.ORS.Models.Volume do
  @moduledoc """
  An ORS Volume.
  """
  use TypedStruct

  typedstruct enforce: true do
    @typedoc "An ORS Volume"

    field :kind, String.t(), default: "volume"
    field :name, String.t()
    field :number, pos_integer
    field :chapter_range, [pos_integer]
  end
end
