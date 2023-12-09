defmodule Day8.Part2Test do
  use ExUnit.Case
  doctest Day8.Part2
  alias Day8.Part2
  import Math

  @sample """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """

  test "a" do
    {inst, map} =
      @sample
      |> Part2.parse_input()

    Part2.navigate("AAA", 0, 0, [], 100, inst, map)
  end

  test "in" do
    {inst, map} =
      Day8.Input.get()
      |> Part2.parse_input()

    start_pos =
      map
      |> Enum.to_list()
      |> Enum.filter(fn
        {k, _v} -> String.ends_with?(k, "A")
      end)
      |> Enum.map(fn {k, _} -> k end)

    [start | rest] =
      start_pos
      |> Enum.map(&Part2.navigate(&1, 0, 0, [], 10, inst, map))
      |> Enum.map(&Part2.get_pattern/1)
      |> List.flatten()

    rest
    |> Enum.reduce(start, fn el, acc -> lcm(el, acc) end)
    |> IO.inspect()

    # 16187743689077
  end
end
