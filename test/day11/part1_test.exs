defmodule Day11.Part1Test do
  use ExUnit.Case
  doctest Day11.Part1
  alias Day11.Part1
  alias Day11.Input

  @sample """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """

  test "parse/1" do
    map =
      @sample
      |> Part1.parse()
  end

  test "sample" do
    map =
      @sample
      |> Part1.parse()

    e = Part1.get_empty_rc(map)

    d = Part1.get_distance({0, 0}, {1, 1}, e)

    assert d == 2

    assert Part1.get_distance({1, 5}, {4, 9}, e) == 9

    stars = Part1.get_stars(map)
    assert length(stars) == 9

    assert Part1.get_combined_distance(stars, e) == 374
  end

  test "input" do
    Input.get()
    |> Part1.run()
  end

  test "part2 sample" do
    @sample
    |> Part1.run(10 - 1) ==
      1030

    assert @sample
           |> Part1.run(100 - 1) ==
             8410
  end

  test "part2 input" do
    Input.get()
    |> Part1.run(1_000_000 - 1)
    |> IO.inspect(charlists: :as_list)

    # 779032247216
  end
end
