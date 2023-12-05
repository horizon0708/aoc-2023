defmodule Day5.Part2Test do
  use ExUnit.Case
  doctest Day5.Part2
  alias Day5.Part2

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

  test "run sample" do
    res =
      @sample
      |> Part2.run()

    assert res == 46
  end

  test "run input" do
    res =
      File.read!("./lib/day5/input.txt")
      |> Part2.run()
      |> IO.inspect()
  end

  test "build_seed_checker/1" do
    checker =
      "seeds: 79 14 55 13"
      |> Part2.build_seed_checker()

    assert checker.(79) == true
    assert checker.(78) == false
    assert checker.(92) == true
    assert checker.(93) == false
  end

  test "build_reversed_checker/1" do
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
      |> Part2.build_reversed_checker()

    assert checker.(46) == 82
  end
end
