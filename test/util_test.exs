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
    assert Util.group_with([1], &is_1?/1) == [[1]]
  end

  test "1 2" do
    assert Util.group_with([1, 2], &is_1?/1) == [[1, 2]]
  end

  test "1 1" do
    assert Util.group_with([1, 1], &is_1?/1) == [[1], [1]]
  end

  test "1 2 3 4" do
    input = [1, 2, 3, 4]
    expected = [[1, 2, 3, 4]]

    assert Util.group_with(input, &is_1?/1) == expected
  end

  test "1 2 3 1 4 5 1 6" do
    input = [1, 2, 3, 1, 4, 5, 1, 6]
    expected = [[1, 2, 3], [1, 4, 5], [1, 6]]

    assert Util.group_with(input, &is_1?/1) == expected
  end

  #
  # Skipping over non-conforming objects
  #

  test "2 2 2 1 2 3" do
    input = [2, 2, 2, 1, 2, 3]
    expected = [[1, 2, 3]]

    assert Util.group_with(input, &is_1?/1) == expected
  end
end
