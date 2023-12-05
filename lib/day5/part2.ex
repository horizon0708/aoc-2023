defmodule Day5.Part2 do
  @moduledoc """

  Naive recursive ascending search fails to finishing within 1 min
  - I wonder if any of the paths overlap. If they don't overlap, no point caching the results.
  - lets try parallelising for now


  """

  def run(input) do
    checker =
      input
      |> parse_input()
      # oh yeah I reverse it later
      |> then(fn {seed, data} -> build_reversed_checker([seed | data]) end)

    recursive_ascending_search(0, checker)
  end

  def recursive_ascending_search(number, cb) do
    case cb.(number) do
      true ->
        number

      false ->
        IO.puts(number)
        recursive_ascending_search(number + 1, cb)
    end
  end

  def parse_input(input) do
    [
      seeds | rest
    ] =
      input
      |> String.split("\n\n")

    seeds = build_seed_checker(seeds)

    data =
      rest
      |> Enum.map(&parse_map/1)

    {seeds, data}
  end

  def build_seed_checker("seeds: " <> numbers) do
    checkers =
      String.split(numbers, " ", trim: true)
      |> Utils.to_integer!()
      |> Enum.chunk_every(2)
      |> Enum.map(&build_seed_checker/1)

    fn input ->
      checkers
      |> Enum.map(fn callback ->
        Task.async(fn -> callback.(input) end)
      end)
      |> Enum.map(&Task.await/1)
      |> Enum.any?()
    end
  end

  def build_seed_checker([start, range]) do
    fn
      input when input >= start and input < start + range -> true
      _ -> false
    end
  end

  def parse_map(lines) do
    [_ | rest] =
      String.split(lines, "\n")

    rest
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Utils.to_integer!()
    |> Enum.map(fn
      [a, b, c] -> {a, b, c}
      _ -> nil
    end)
    |> Enum.filter(&(not is_nil(&1)))
    |> Enum.sort_by(fn {a, _, _} -> a end, :asc)
  end

  def build_reversed_checker(parts) do
    fn input ->
      parts
      |> Enum.reverse()
      |> Enum.map(&build_parallel_checker/1)
      |> Enum.reduce(input, fn callback, acc ->
        callback.(acc)
      end)
    end
  end

  # build checker that runs all checkers in parallel and returns one value
  # or value as is if there is none
  def build_parallel_checker(maps) when is_list(maps) do
    fn input ->
      maps
      |> Enum.map(&build_checker/1)
      |> Enum.map(fn callback ->
        Task.async(fn -> callback.(input) end)
      end)
      |> Enum.map(&Task.await/1)
      # |> IO.inspect(charlists: :as_lists)
      |> Enum.filter(&(not is_nil(&1)))
      |> case do
        [n] -> n
        _ -> input
      end
    end
  end

  def build_parallel_checker(callback), do: callback

  def build_checker({a, b, n}) do
    fn
      input when input >= a and input < a + n ->
        b + (input - a)

      _ ->
        nil
    end
  end
end
