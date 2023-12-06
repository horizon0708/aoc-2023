defmodule Day5.Part2 do
  @moduledoc """

  #try 1
  Naive recursive ascending search fails to finishing within 1 min
  - For caching: I wonder if any of the paths overlap. If they don't overlap, no point caching the results.
  - lets try parallelising for now

  #try 2
  parallel processing is probably too slow as well
  - lets check if mappings overlap
    - there seem to be no cache hit - which I suspected but wanted to check
  - hmm I'm building checkers on every run... probably not very efficient
   - turns out that doesn't change that much

  I thought the code as it is was way too slow for some reason,
  realised `build_parallel_checker` absoutely did NOT need to be parallel :joy:
  (neither does build_seed_checker 40s -> 5s)

  #try 3
  hmm maybe lets search first for a approximate value and go down from there.
  Instead of incrementing by 1, increment by 10000

  increment | value
  --- | ---
  10000 | 50720000
  1000  | 50717000

  Now lets change the starting point to 50_000_000
  then try make the increment finer

  increment | value
  --- | ---
  100 | 50716500
  10  | 50716420
  1  | 50716416

  got it! :D
  """

  def run(input) do
    checker =
      input
      |> parse_input()
      # oh yeah I reverse it later
      |> then(fn {seed, data} -> build_reversed_checker([seed | data]) end)

    # 50..61
    # |> Enum.map(fn n -> n * 500_000 end)
    # |> Enum.chunk_every(2, 1, :discard)
    # |> Enum.map(fn [s, e] ->
    #   Task.async(fn ->
    #     recursive_ascending_search(s, e, checker)
    #   end)
    # end)
    # |> Enum.map(&Task.await(&1, 50_000))

    recursive_ascending_search(50_000_000, 50_000_000 * 10, checker)
  end

  def recursive_ascending_search(number, limit, cb) do
    cond do
      number == limit ->
        nil

      cb.(number) ->
        number

      true ->
        recursive_ascending_search(number + 1, limit, cb)
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
      # Note to self: don't ever do this again
      # |> Enum.map(fn callback ->
      #   Task.async(fn -> callback.(input) end)
      # end)
      # |> Enum.map(&Task.await/1)
      |> Enum.map(fn callback -> callback.(input) end)
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
    checkers =
      parts
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.map(&build_parallel_checker/1)

    fn input ->
      checkers
      |> Enum.reduce(input, fn callback, acc ->
        callback.(acc)
      end)
    end
  end

  # build checker that runs all checkers in parallel and returns one value
  # or value as is if there is none
  def build_parallel_checker({maps, _ind}) when is_list(maps) do
    # build ets per stage as a cache

    checkers =
      maps
      |> Enum.map(&build_checker/1)

    fn input ->
      checkers
      |> Enum.map(fn callback -> callback.(input) end)
      # |> Enum.map(fn callback ->
      #   Task.async(fn -> callback.(input) end)
      # end)
      # |> Enum.map(&Task.await/1)
      # |> IO.inspect(charlists: :as_lists)
      |> Enum.filter(&(not is_nil(&1)))
      |> case do
        [n] -> n
        _ -> input
      end

      # |> tap(fn output -> add_to_cache(input, output, ref) end)
    end
  end

  def build_parallel_checker({callback, _ind}), do: callback

  def build_checker({a, b, n}) do
    fn
      input when input >= a and input < a + n ->
        b + (input - a)

      _ ->
        nil
    end
  end
end
