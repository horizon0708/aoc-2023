defmodule Day4.Part2Test do
  use ExUnit.Case
  doctest Day4.Part2
  alias Day4.Part2

  @sample """
  Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
  """

  test "sample run/1" do
    res =
      @sample
      |> Part2.run()

    assert res == 30
  end

  test "parse_lines/1" do
    res =
      @sample
      |> Part2.parse_lines()

    assert res == %{1 => {1, 4}, 2 => {1, 2}, 3 => {1, 2}, 4 => {1, 1}, 5 => {1, 0}, 6 => {1, 0}}
  end

  test "input run/1" do
    File.read!("./lib/day4/input.txt")
    |> Part2.run()

    # 14814534
  end
end
