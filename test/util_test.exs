defmodule UtilTest do
  @moduledoc """
  Test Util module.
  """

  import Util, only: [group_with: 2, remove_trailing_period: 1]

  use ExUnit.Case, async: true
  doctest Util


  describe "group_with/2" do
    test "1" do
      assert group_with([1], &(&1 == 1)) == [[1]]
    end

    test "1 2" do
      assert group_with([1, 2], &(&1 == 1)) == [[1, 2]]
    end

    test "1 1" do
      assert group_with([1, 1], &(&1 == 1)) == [[1], [1]]
    end

    test "1 2 3 4" do
      input = [1, 2, 3, 4]
      expected = [[1, 2, 3, 4]]

      assert group_with(input, &(&1 == 1)) == expected
    end

    #
    # Make sure the lists aren't reversed
    #

    test "1 2 3 1 4 5 1 6" do
      input = [1, 2, 3, 1, 4, 5, 1, 6]
      expected = [[1, 2, 3], [1, 4, 5], [1, 6]]

      assert group_with(input, &(&1 == 1)) == expected
    end

    #
    # Skipping over non-conforming objects
    #

    test "2 2 2 1 2 3" do
      input = [2, 2, 2, 1, 2, 3]
      expected = [[1, 2, 3]]

      assert group_with(input, &(&1 == 1)) == expected
    end
  end
end
