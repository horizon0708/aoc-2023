defmodule Day3 do
  def run_input() do
    File.stream!("./lib/day3/input.txt")
    |> Stream.chunk_every(2, 1)
    |> run()
  end

  def run(enumerable) do
    enumerable
    |> Enum.reduce(
      {0, []},
      fn
        [curr, next], {sum, prev_sym_pos} ->
          cur_sym_pos =
            get_symbol_pos(curr)

          next_sym_pos = get_symbol_pos(next)

          hits =
            get_aggregate_collision_indexes([prev_sym_pos, cur_sym_pos, next_sym_pos])

          new_sum =
            get_numbers(curr, hits)
            |> Enum.reduce(sum, fn n, acc -> n + acc end)
            |> dbg

          {new_sum, cur_sym_pos}

        [curr], {sum, prev_sym_pos} ->
          cur_sym_pos = get_symbol_pos(curr)
          hits = get_aggregate_collision_indexes([prev_sym_pos, cur_sym_pos])

          new_sum =
            get_numbers(curr, hits)
            |> Enum.reduce(sum, fn n, acc -> n + acc end)
            |> dbg

          {new_sum, cur_sym_pos}
      end
    )
  end

  def get_symbol_pos(line) when is_binary(line) do
    line
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.filter(fn
      {x, _} -> x != "." and x not in ~w(0 1 2 3 4 5 6 7 8 9)
    end)
    |> Enum.map(fn
      {_, ind} -> ind
    end)
  end

  def get_aggregate_collision_indexes(lists) do
    lists
    |> Enum.map(&get_collision_area/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  def get_collision_area(symbols) when is_list(symbols) do
    symbols
    |> Enum.map(&get_collision_area/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  def get_collision_area(symbol_pos) when is_integer(symbol_pos) do
    [symbol_pos - 1, symbol_pos, symbol_pos + 1]
  end

  def get_numbers(line, hits) when is_binary(line) and is_list(hits) do
    line
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.chunk_while(
      [],
      fn
        # integers
        {n, _} = el, acc when n in ~w(0 1 2 3 4 5 6 7 8 9) ->
          {:cont, acc ++ [el]}

        # non-integer, nothing in acc. move on.
        _, [] ->
          {:cont, []}

        # non-integer, emit number as chunk if they are adjacent. Clear acc.
        _, acc ->
          if adj?(acc, hits) do
            {:cont, to_number!(acc), []}
          else
            {:cont, []}
          end
      end,
      fn acc -> {:cont, acc} end
    )
  end

  def adj?(np, hits) do
    hits = MapSet.new(hits)

    np
    |> Enum.map(fn {_, ind} -> ind end)
    |> MapSet.new()
    |> MapSet.disjoint?(hits)
    |> then(&(not &1))
  end

  def to_number!(np) do
    np
    |> Enum.reduce("", fn {n, _}, acc -> acc <> n end)
    |> Integer.parse()
    |> case do
      {int, _} -> int
      _ -> raise "should be integer!"
    end
  end
end
