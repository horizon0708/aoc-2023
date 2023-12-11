defmodule Day10.Part2Test do
  use ExUnit.Case
  alias Day10.Input
  alias Day10.Part2

  @simple """
  ...........
  .S-------7.
  .|F-----7|.
  .||.....||.
  .||.....||.
  .|L-7.F-J|.
  .|..|.|..|.
  .L--J.L--J.
  ...........
  """

  @complex """
  FF7FSF7F7F7F7F7F---7
  L|LJ||||||||||||F--J
  FL-7LJLJ||||||LJL-77
  F--JF--7||LJLJ7F7FJ-
  L---JF-JLJ.||-FJLJJ7
  |F|F-JF---7F7-L7L|7|
  |FFJF7L7F-JF7|JL---7
  7-L-JL7||F7|L7F-7F7|
  L.L7LFJ|||||FJL7||LJ
  L7JLJL-JLJLJL--JLJ.L
  """

  test "simple" do
    n =
      @simple
      |> Part2.find_loop()

    assert n == 4
  end

  test "complex" do
    n =
      @complex
      |> Part2.find_loop()

    assert n == 10
  end

  test "input" do
    n =
      Input.get()
      |> Part2.find_loop()

    assert n == 287
  end
end
