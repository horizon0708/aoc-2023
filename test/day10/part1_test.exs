defmodule Day10.Part1Test do
  use ExUnit.Case
  alias Day10.Input
  alias Day10.Part1

  @simple """
  .....
  .S-7.
  .|.|.
  .L-J.
  .....
  """

  @complex """
  7-F7-
  .FJ|7
  SJLL7
  |F--J
  LJ.LJ
  """

  test "find loop" do
    @simple
    |> Part1.find_loop()

    # |> IO.inspect(charlists: :as_list)
  end

  test "complex loop" do
    @complex
    |> Part1.find_loop()
  end

  test "input" do
    Input.get()
    |> Part1.find_loop()
    |> IO.inspect(charlists: :as_list)
  end
end
