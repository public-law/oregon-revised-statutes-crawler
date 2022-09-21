defmodule Crawlers.ORS.Models.Volume do
  @moduledoc """
  An ORS Volume.
  """

  # defstruct [:name]

  use TypedStruct

  typedstruct enforce: true do
    @typedoc "An ORS Volume"

    field(:name, String.t())
  end
end
