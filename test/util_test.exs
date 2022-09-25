defmodule UtilTest do
  @moduledoc """
  Test Util module.
  """
  # import List
  use ExUnit.Case, async: true

  def is_1?(value) do
    value == 1
  end

  test "1" do
    assert Util.group_until([1], &is_1?/1) == [[1]]
  end

  test "1 2" do
    assert Util.group_until([1, 2], &is_1?/1) == [[1, 2]]
  end

  test "1 1" do
    assert Util.group_until([1, 1], &is_1?/1) == [[1], [1]]
  end

  test "1 2 2" do
    input = [1, 2, 2]
    expected = [[1, 2, 2]]

    assert Util.group_until(input, &is_1?/1) == expected
  end

  test "1 2 2 1 2 2" do
    input = [1, 2, 2, 1, 2, 2]
    expected = [[1, 2, 2], [1, 2, 2]]

    assert Util.group_until(input, &is_1?/1) == expected
  end

  #
  # Skipping over non-conforming objects
  #

  test "2 2 2 1 2 2" do
    input = [2, 2, 2, 1, 2, 2]
    expected = [[1, 2, 2]]

    assert Util.group_until(input, &is_1?/1) == expected
  end
end
