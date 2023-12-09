defmodule Day8.Part2 do
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

  def navigate(curr, ind, step, numbers, limit, instruction, map) do
    {l, r} = Map.get(map, curr)

    pos =
      case Enum.at(instruction, ind) do
        "L" -> l
        "R" -> r
      end

    numbers =
      if String.ends_with?(pos, "Z") do
        numbers ++ [step]
      else
        numbers
      end

    step = step + 1

    if length(numbers) >= limit do
      numbers
    else
      navigate(pos, next_ind(ind, instruction), step, numbers, limit, instruction, map)
    end
  end

  def next_ind(ind, instruction) do
    cond do
      ind + 1 >= length(instruction) -> 0
      true -> ind + 1
    end
  end

  def get_pattern(numbers) do
    numbers
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn
      [a, b] -> b - a
    end)
    |> Enum.uniq()
  end
end
