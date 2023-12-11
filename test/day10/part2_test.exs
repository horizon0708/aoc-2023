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

  test "simple" do
    @simple
    |> Part2.find_loop()
    |> IO.inspect(charlists: :as_list)
  end
end
