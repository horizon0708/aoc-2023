defmodule Day11.Part1 do
  def run(input, mult \\ 1) do
    map =
      input
      |> parse()

    rc = get_empty_rc(map)
    stars = get_stars(map)
    get_combined_distance(stars, rc, mult)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce([], fn {row, y}, acc ->
      row
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {item, x} -> {{x, y}, item} end)
      |> then(&(acc ++ &1))
    end)
    |> Map.new()
  end

  def get_stars(map) do
    map
    |> Enum.filter(fn
      {_, "#"} -> true
      _ -> false
    end)
  end

  def get_combined_distance(stars, ex, mult \\ 1) do
    combinations(stars, 2)
    |> Enum.map(fn [{a, _}, {b, _}] ->
      get_distance(a, b, ex, mult)
    end)
    |> Enum.sum()
  end

  def combinations(enum, k) do
    List.last(do_combinations(enum, k))
    |> Enum.uniq()
  end

  defp do_combinations(enum, k) do
    combinations_by_length = [[[]] | List.duplicate([], k)]

    list = Enum.to_list(enum)

    List.foldr(list, combinations_by_length, fn x, next ->
      sub = :lists.droplast(next)
      step = [[] | for(l <- sub, do: for(s <- l, do: [x | s]))]
      :lists.zipwith(&:lists.append/2, step, next)
    end)
  end

  def get_distance({ax, ay}, {bx, by}, %{rows: rows, cols: cols}, mult \\ 1) do
    dy = abs(by - ay)
    dx = abs(bx - ax)

    xx = number_of_expanding_spaces(ax, bx, cols) * mult
    yy = number_of_expanding_spaces(ay, by, rows) * mult

    dy + yy + dx + xx
  end

  def number_of_expanding_spaces(a, b, arr) do
    [a, b] = Enum.sort([a, b], :asc)

    arr
    |> Enum.filter(fn n ->
      a < n and n < b
    end)
    |> length()
  end

  def get_empty_rc(map) do
    max_col = length(get_row(map, 0)) - 1
    max_row = length(get_col(map, 0)) - 1

    empty_rows =
      0..max_col
      |> Enum.map(fn n -> get_row(map, n) end)
      |> Enum.filter(&empty?/1)
      |> Enum.map(fn [{{_, y}, _} | _] -> y end)

    empty_cols =
      0..max_row
      |> Enum.map(fn n -> get_col(map, n) end)
      |> Enum.filter(&empty?/1)
      |> Enum.map(fn [{{x, _}, _} | _] -> x end)

    %{
      rows: empty_rows,
      cols: empty_cols
    }
  end

  def get_col(map, x) do
    map
    |> Enum.filter(fn {{rx, _}, _} -> rx == x end)
  end

  def get_row(map, y) do
    map
    |> Enum.filter(fn {{_, ry}, _} -> ry == y end)
  end

  def empty?(items) do
    items
    |> Enum.all?(fn
      {_, "."} -> true
      _ -> false
    end)
  end
end
