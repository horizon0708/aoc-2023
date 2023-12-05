defmodule Day4.Part2 do
  def run(lines) do
    lines
    |> parse_lines()
    |> process_cards()
    |> Enum.reduce(0, fn {_, {c, _}}, acc -> acc + c end)
  end

  def parse_lines(lines) when is_binary(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Map.new()
  end

  def parse_line(line) when is_binary(line) do
    ["Card " <> n, numbers] = String.split(line, ":", trim: true)

    # card number, {multiplier, wins}
    {to_integer!(n), {1, get_wins(numbers)}}
  end

  def get_wins(numbers) when is_binary(numbers) do
    [wn, n] =
      String.split(numbers, "|", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(&MapSet.new(&1))

    MapSet.intersection(wn, n)
    |> MapSet.to_list()
    |> length()
  end

  def to_integer!(b) when is_binary(b) do
    b
    |> String.trim()
    |> Integer.parse()
    |> case do
      {n, _} -> n
      _ -> raise "should be int! #{inspect(b)}"
    end
  end

  def process_cards(card_map) do
    1..(length(Map.to_list(card_map)) - 1)
    |> Enum.reduce(card_map, fn key, acc ->
      card = Map.get(acc, key)
      add_cards({key, card}, acc)
    end)
  end

  def add_cards({_cn, {_mult, 0}}, card_map), do: card_map

  def add_cards({cn, {multiplier, wins}}, card_map) do
    range_start = cn + 1
    range_end = min(cn + wins, length(Map.to_list(card_map)))

    range_start..range_end
    |> Enum.reduce(card_map, fn n, acc ->
      add_cards(acc, n, multiplier)
    end)
  end

  def add_cards(card_map, card_number, multiplier) do
    card_map
    |> Map.update!(card_number, fn {n, w} -> {n + multiplier, w} end)
  end
end
