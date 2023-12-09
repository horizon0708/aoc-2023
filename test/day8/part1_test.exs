defmodule Day8.Part1Test do
  use ExUnit.Case
  doctest Day8.Part1
  alias Day8.Part1

  @sample """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """

  test "" do
    @sample
    |> Part1.parse_input()
    |> IO.inspect(charlists: :as_list)
  end

  test "a" do
    {inst, map} =
      @sample
      |> Part1.parse_input()

    Part1.navigate("AAA", 0, 0, inst, map)
    |> IO.inspect(charlists: :as_list)
  end

  test "in" do
    {inst, map} =
      Day8.Input.get()
      |> Part1.parse_input()

    Part1.navigate("AAA", 0, 0, inst, map)
    |> IO.inspect(charlists: :as_list)
  end
end
