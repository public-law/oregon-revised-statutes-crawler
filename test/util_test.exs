defmodule UtilTest do
  @moduledoc """
  Test Util module.
  """
  # import List
  use ExUnit.Case, async: true

  def is_true?(value) do
    value == true
  end

  test "One true" do
    assert Util.group_until([true], &is_true?/1) == [[true]]
  end

  test "true false" do
    assert Util.group_until([true, false], &is_true?/1) == [[true, false]]
  end
end
