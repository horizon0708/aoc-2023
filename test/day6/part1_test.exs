defmodule Day6.Part1Test do
  use ExUnit.Case
  doctest Day6.Part1
  alias Day6.Part1

  @sample [
    {7, 9},
    {15, 40},
    {30, 200}
  ]

  @input [
    {35, 213},
    {69, 1168},
    {68, 1086},
    {87, 1248}
  ]

  test "sample run" do
    n =
      @sample
      |> Part1.run()

    assert n == 288
  end

  test "input run" do
    @input
    |> Part1.run()

    # 170000
  end
end
