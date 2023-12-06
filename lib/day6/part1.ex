defmodule Day6.Part1 do
  def run(races) do
    races
    |> Enum.map(&brute_force/1)
    |> Enum.reduce(1, fn t, acc -> acc * t end)
  end

  def brute_force({time, distance}) do
    1..time
    |> Enum.map(fn speed -> wins?(speed, {time, distance}) end)
    |> Enum.filter(fn wins? -> wins? end)
    |> length
  end

  def wins?(speed, {time, distance}) do
    remaining = time - speed
    remaining * speed > distance
  end
end
