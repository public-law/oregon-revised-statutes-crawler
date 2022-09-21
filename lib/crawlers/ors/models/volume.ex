defmodule Volume do
  @moduledoc """
  An ORS Volume.
  """

  use TypedStruct

  typedstruct enforce: true do
    @typedoc "An ORS Volume"

    field(:name, String.t())
  end
end
