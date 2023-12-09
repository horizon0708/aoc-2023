defmodule Day9.Part2Test do
  use ExUnit.Case
  doctest Day9.Part2
  alias Day9.Input
  alias Day9.Part2

  @sample """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """

  test "sample" do
    res =
      @sample
      |> Part2.parse()
      |> Enum.map(&Part2.get_prev_number/1)
      |> Enum.sum()

    assert res == 2
  end

  test "get_prev_n" do
    inc =
      [10, 13, 16, 21, 30, 45]
      |> Part2.get_prev_number()
  end

  test "input" do
    res =
      Input.get()
      |> Part2.parse()
      |> Enum.map(&Part2.get_prev_number/1)
      |> Enum.sum()

    assert res == 1131
  end
end
