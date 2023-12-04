defmodule Day3Test do
  use ExUnit.Case

  @input """
  ...........441.................367................296........................................567..47.....45.................947.............
  ...606..........888.....................508..........*892................+..=138.381..967...............*....%......926...........218.......
  ....*......116..*..............747............-....................777..460..........*.......549......127...595.......*..290........*.968...
  """

  @sample """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  test "start" do
    # [l1, l2, l3, ""] = String.split(@input, "\n")

    @sample
    |> String.split("\n")
    |> Enum.chunk_every(2, 1)
    |> Day3.run()
    |> dbg(structs: false)

    Day3.run_input()
    |> dbg(structs: false)

    # Day3.get_symbol_pos(l1)
    # |> dbg(structs: false)

    # hits =
    #   Day3.get_symbol_pos(l2)
    #   |> Day3.get_collision_area()

    # # |> dbg(structs: false, charlists: :as_lists)

    # Day3.get_numbers(l2, hits)
    # |> dbg(structs: false, charlists: :as_lists)
  end
end
