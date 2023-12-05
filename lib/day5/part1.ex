defmodule Day5.Part1 do
  def run(input, opts \\ []) do
    {seeds, checker} =
      input
      |> parse_input(opts)
      |> then(fn {seed, data} -> {seed, build_connected_checker(data)} end)

    seeds
    |> Enum.map(&checker.(&1))
    |> Enum.sort(:asc)
    |> Enum.at(0)
  end

  def parse_input(input, opts \\ []) do
    [
      seeds | rest
    ] =
      input
      |> String.split("\n\n")

    seed_getter = Keyword.get(opts, :seed_getter, &get_seeds/1)

    seeds =
      seeds
      |> seed_getter.()

    data =
      rest
      |> Enum.map(&parse_map/1)

    {seeds, data}
  end

  defp get_seeds("seeds: " <> numbers) do
    String.split(numbers, " ", trim: true)
    |> Utils.to_integer!()
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

  # lol naming is hard
  def build_connected_checker(parts) do
    fn input ->
      parts
      |> Enum.map(&build_parallel_checker/1)
      |> Enum.reduce(input, fn callback, acc ->
        callback.(acc)
      end)
    end
  end

  # build checker that runs all checkers in parallel and returns one value
  def build_parallel_checker(maps) do
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

  def build_checker({a, b, n}) do
    fn
      input when input >= b and input < b + n ->
        a + (input - b)

      _ ->
        nil
    end
  end
end
