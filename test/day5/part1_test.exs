defmodule Day5.Part1Test do
  use ExUnit.Case
  doctest Day5.Part1
  alias Day5.Part1

  @sample """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """

  test "input run" do
    File.read!("./lib/day5/input.txt")
    |> Part1.run()

    # 309796150
  end

  test "sample run" do
    res =
      @sample
      |> Part1.run()

    assert res == 35
  end

  test "parse_input/1" do
    @sample
    |> Part1.parse_input()

    # |> IO.inspect()
  end

  test "build_parallel_checker/1" do
    agg_checker =
      [{50, 98, 2}, {52, 50, 48}]
      |> Part1.build_parallel_checker()

    assert agg_checker.(98) == 50
    assert agg_checker.(79) == 81
    assert agg_checker.(14) == 14
  end

  test "build_connected_checker/1" do
    checker =
      [
        [{50, 98, 2}, {52, 50, 48}],
        [{0, 15, 37}, {37, 52, 2}, {39, 0, 15}],
        [{0, 11, 42}, {42, 0, 7}, {49, 53, 8}, {57, 7, 4}],
        [{18, 25, 70}, {88, 18, 7}],
        [{45, 77, 23}, {68, 64, 13}, {81, 45, 19}],
        [{0, 69, 1}, {1, 0, 69}],
        [{56, 93, 4}, {60, 56, 37}]
      ]
      |> Part1.build_connected_checker()

    assert checker.(79) == 82
    assert checker.(14) == 43
    assert checker.(55) == 86
    assert checker.(13) == 35
  end
end
