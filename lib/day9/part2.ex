defmodule Day9.Part2 do
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, " ", trim: true)
      |> Enum.map(&Utils.to_integer!/1)
    end)
  end

  def get_prev_number(numbers) when numbers != [] do
    [n | _] = numbers

    incs =
      get_prev_increments(numbers)

    (incs ++ [n])
    |> Enum.reduce(0, fn i, acc -> i - acc end)
  end

  def get_prev_number(_), do: 0

  def get_prev_increments(numbers, diffs \\ []) do
    diff =
      numbers
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)

    case Enum.all?(diff, fn a -> a == 0 end) do
      true ->
        [0 | diffs]

      false ->
        [l | _] = diff
        get_prev_increments(diff, [l | diffs])
    end
  end
end
