defmodule Day6.Part2Test do
  use ExUnit.Case
  doctest Day6.Part2
  alias Day6.Part2
  alias Day6.Part1

  @sample {71530, 940_200}
  @input {35_696_887, 213_116_810_861_248}

  test "input run" do
    n =
      @input
      |> Part2.run()
      |> IO.inspect()

    # 20537782
  end

  test "sample run" do
    n =
      @sample
      |> Part2.run()

    assert n == 71503
  end
end
