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

  @test """
  .1
  *.
  """

  @line ".............953.......*........................*....719....$......................473.....=...523......-.......723..................*......"
  @line2 "....................571.......................720..........269...........885.............................902...........80...738..........975"

  test "start" do
    [l1, l2, l3, ""] = String.split(@input, "\n")
    IO.inspect(length(String.codepoints(l2)))

    # @sample
    # |> String.split("\n")
    # |> Enum.filter(fn
    #   "" -> false
    #   n -> true
    # end)
    # |> Enum.chunk_every(2, 1)
    # |> Day3.run()
    # |> dbg(structs: false)

    {res, []} =
      Day3.run_input()

    # |> dbg(structs: false)

    assert res == 512_794

    #   @line
    #   |> Day3.get_symbol_pos()
    #   |> dbg()

    #   @line2
    #   |> Day3.get_symbol_pos()
    #   |> dbg()
  end
end
