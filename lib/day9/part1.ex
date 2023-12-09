defmodule Day9.Part1 do
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, " ", trim: true)
      |> Enum.map(&Utils.to_integer!/1)
    end)
  end

  def get_next_number(numbers) when numbers != [] do
    [n | _] = Enum.reverse(numbers)

    incs = get_next_increments(numbers)

    (incs ++ [n])
    |> Enum.sum()
  end

  def get_next_number(_), do: 0

  def get_next_increments(numbers, diffs \\ []) do
    diff =
      numbers
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)

    case Enum.all?(diff, fn a -> a == 0 end) do
      true ->
        diffs

      false ->
        [l | _] = Enum.reverse(diff)
        get_next_increments(diff, diffs ++ [l])
    end
  end
end
