defmodule Day8.Part1 do
  def parse_input(text) do
    [instruction | map] =
      text
      |> String.split("\n", trim: true)

    map =
      map
      |> Enum.map(fn x ->
        x
        |> String.split(["=", "(", ")", ",", " "], trim: true)
        |> then(fn [key, l, r] -> {key, {l, r}} end)
      end)
      |> Map.new()

    {
      String.codepoints(instruction),
      map
    }
  end

  def navigate(curr, ind, step, instruction, map) do
    {l, r} = Map.get(map, curr)

    case Enum.at(instruction, ind) do
      "L" -> l
      "R" -> r
    end
    |> case do
      "ZZZ" -> step + 1
      pos -> navigate(pos, next_ind(ind, instruction), step + 1, instruction, map)
    end
  end

  def next_ind(ind, instruction) do
    cond do
      ind + 1 >= length(instruction) -> 0
      true -> ind + 1
    end
  end
end
