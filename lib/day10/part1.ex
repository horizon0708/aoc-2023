defmodule Day10.Part1 do
  def find_loop(text) do
    d_map =
      text
      |> to_2d_array()

    {x, y} = find_starting_point(d_map)

    loop =
      d_map
      |> get_all_branching_pipes(x, y, [])
      |> List.flatten()
      |> Enum.uniq()

    answer =
      loop
      |> Enum.map(fn x ->
        x
        |> Enum.to_list()
        |> length()
      end)
      |> Enum.max()
      |> then(&Utils.to_integer!(inspect(&1 / 2)))

    # File.write!("./lib/day10/loop.txt", inspect(Enum.to_list(loop)))

    answer
  end

  def to_2d_array(text) do
    text
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.codepoints()
      |> Enum.with_index()
    end)
    |> Enum.with_index()
  end

  def find_starting_point(d_map) do
    d_map
    |> Enum.reduce(nil, fn {row, row_ind}, acc ->
      case Enum.find(row, fn {col, _} -> col === "S" end) do
        {_, col_ind} -> {row_ind, col_ind}
        _ -> acc
      end
    end)
  end

  def get_tile_at(d_map, {x, y}), do: get_tile_at(d_map, x, y)

  def get_tile_at(d_map, x, y) do
    d_map
    |> Enum.reduce(nil, fn
      {row, row_ind}, acc when row_ind == y ->
        case Enum.find(row, fn {_, col_ind} -> col_ind == x end) do
          {col, _} -> col
          _ -> acc
        end

      _, acc ->
        acc
    end)
  end

  # def get_elligible_neighbors(d_map, {})

  def get_possible_positions([{row, _} | _] = d_map, x, y) do
    max_y = length(d_map)
    max_x = length(row)

    left = max(x - 1, 0)
    up = max(y - 1, 0)
    right = min(x + 1, max_x)
    down = min(y + 1, max_y)
    tile = get_tile_at(d_map, x, y)

    [
      {:left, {left, y}},
      {:right, {right, y}},
      {:up, {x, up}},
      {:down, {x, down}}
    ]
    |> Enum.filter(fn {_, {new_x, new_y}} ->
      not (new_x == x and new_y == y)
    end)
    |> Enum.filter(fn {dir, _} -> valid_direction?(tile, dir) end)
    |> Enum.filter(fn tile -> valid_tile?(d_map, tile) end)
    |> Enum.map(fn {_, pos} -> pos end)
  end

  def valid_direction?(tile, dir) do
    case tile do
      "S" -> dir in [:left, :right, :up, :down]
      "|" -> dir in [:up, :down]
      "-" -> dir in [:left, :right]
      "F" -> dir in [:down, :right]
      "L" -> dir in [:up, :right]
      "7" -> dir in [:left, :down]
      "J" -> dir in [:left, :up]
    end
  end

  def valid_tile?(d_map, {:left, pos}) do
    get_tile_at(d_map, pos) in ["-", "L", "F", "S"]
  end

  def valid_tile?(d_map, {:right, pos}) do
    get_tile_at(d_map, pos) in ["-", "J", "7", "S"]
  end

  def valid_tile?(d_map, {:up, pos}) do
    get_tile_at(d_map, pos) in ["|", "F", "7", "S"]
  end

  def valid_tile?(d_map, {:down, pos}) do
    get_tile_at(d_map, pos) in ["|", "L", "J", "S"]
  end

  @doc """
  Need to think about branching paths
  """
  def get_all_branching_pipes(d_map, x, y, tiles) do
    tiles =
      (Enum.to_list(tiles) ++ [{x, y}])
      |> MapSet.new()

    d_map
    |> get_possible_positions(x, y)
    |> case do
      [] ->
        tiles

      pos ->
        pos
        |> MapSet.new()
        |> MapSet.difference(tiles)
        |> Enum.to_list()
        |> case do
          [] ->
            tiles

          l ->
            l
            |> Enum.map(fn {x, y} -> get_all_branching_pipes(d_map, x, y, tiles) end)
        end
    end
  end
end
