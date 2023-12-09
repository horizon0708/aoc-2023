defmodule Day9.Part1Test do
  use ExUnit.Case
  doctest Day9.Part1
  alias Day9.Input
  alias Day9.Part1

  @sample """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """

  test "sample" do
    res =
      @sample
      |> Part1.parse()
      |> Enum.map(&Part1.get_next_number/1)
      |> Enum.sum()

    assert res == 114
  end

  test "input" do
    res =
      Input.get()
      |> Part1.parse()
      |> Enum.map(&Part1.get_next_number/1)
      |> Enum.sum()

    assert res == 1_955_513_104
  end

  test "diff" do
    inc =
      [10, 13, 16, 21, 30, 45]
      |> Part1.get_next_increments()

    assert inc == [15, 6, 2]
  end
end
