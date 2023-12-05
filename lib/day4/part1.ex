defmodule Day4.Part1 do
  def run(lines) do
    lines
    |> Enum.reduce(0, fn line, acc ->
      acc + get_points(line)
    end)
  end

  def get_points(line) when is_binary(line) do
    [_, numbers] = String.split(line, ":", trim: true)

    [wn, n] =
      String.split(numbers, "|", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(&MapSet.new(&1))

    wn_count =
      MapSet.intersection(wn, n)
      |> MapSet.to_list()
      |> length()

    :math.pow(2, wn_count - 1)
    |> floor()
  end
end
