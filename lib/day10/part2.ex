defmodule Day10.Part2 do
  def find_loop(text) do
    d_map =
      text
      |> to_2d_array()

    {x, y} =
      find_starting_point(d_map)

    # brute force the loop
    loop =
      d_map
      |> get_all_branching_pipes(x, y, [])
      |> Enum.map(fn x ->
        x
        |> List.flatten()
        |> Enum.at(0)
      end)
      |> Enum.uniq()
      |> Enum.map(fn x ->
        x
        |> Enum.to_list()
      end)
      |> Enum.max_by(&length/1)

    # get what the S tile is meant to be (in this case its "|")
    s = determine_starting_tile(d_map, loop, {x, y})

    # and replace that tile so its easy to follow
    d_map = replace_at(d_map, s, {x, y})

    # find the first (most top-left) F in the loop
    {sx, sy} = find_first_marker(d_map, "F", loop) |> IO.inspect()

    # traverse the loop from in clockwise, and add all points that we know are in the loop
    points =
      trav_cw_and_add_insides(loop, d_map, {sx + 1, sy}, {sx + 1, sy}, :right)

    MapSet.new(points)
    |> MapSet.difference(MapSet.new(loop))
    # once we get all the points, we "fill" from those points
    |> Enum.reduce([], fn x, acc ->
      (acc ++ get_area(x, loop, acc))
      |> List.flatten()
      |> Enum.uniq()
    end)
    |> length
  end

  def get_area({x, y} = pos, l, area \\ []) do
    if pos in area or pos in l do
      area
    else
      area = area ++ [pos]

      get_adj_pos(x, y)
      |> Enum.reduce(area, fn xp, acc -> get_area(xp, l, acc) end)
    end
  end

  def replace_at(map, t, {x, y}) when is_binary(t) do
    map
    |> Enum.map(fn
      {row, row_ind} when row_ind == y ->
        {Enum.map(
           row,
           fn
             {_, col_ind} when col_ind == x ->
               {t, col_ind}

             el ->
               el
           end
         ), row_ind}

      el ->
        el
    end)
  end

  def replace_at(map, ref, {x, y}) do
    replace_at(map, get_tile_at(ref, {x, y}), {x, y})
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

  def find_starting_point(d_map, marker \\ "S") do
    d_map
    |> Enum.reduce(nil, fn {row, row_ind}, acc ->
      case Enum.find(row, fn {col, _} -> col === marker end) do
        {_, col_ind} -> {col_ind, row_ind}
        _ -> acc
      end
    end)
  end

  def find_first_marker(d_map, marker, loop) do
    d_map
    |> Enum.reduce(nil, fn
      {row, row_ind}, nil ->
        case Enum.find(row, fn {col, col_ind} -> col === marker and {col_ind, row_ind} in loop end) do
          {_, col_ind} -> {col_ind, row_ind}
          _ -> nil
        end

      _, acc ->
        acc
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

  def get_adj_pos(x, y) do
    left = max(x - 1, 0)
    up = max(y - 1, 0)
    right = x + 1
    down = y + 1

    [
      {left, y},
      {right, y},
      {x, up},
      {x, down}
    ]
  end

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

  def determine_starting_tile(d_map, loop, {x, y}) do
    adj_pos =
      get_possible_positions(d_map, x, y)
      |> MapSet.new()
      |> MapSet.intersection(MapSet.new(loop))
      |> MapSet.to_list()

    dir =
      adj_pos
      |> Enum.map(fn {ex, ey} -> {ex - x, ey - y} end)
      |> IO.inspect(charlists: :as_list)
      |> Enum.map(fn
        {1, 0} -> {:right, 3}
        {-1, 0} -> {:left, 2}
        {0, 1} -> {:down, 1}
        {0, -1} -> {:up, 0}
      end)
      |> Enum.sort_by(fn {_, p} -> p end)
      |> Enum.map(fn {dir, _} -> dir end)

    cond do
      dir == [:down, :right] ->
        "F"

      dir == [:up, :right] ->
        "L"

      dir == [:down, :left] ->
        "7"

      dir == [:up, :left] ->
        "J"

      dir == [:left, :right] ->
        "-"

      dir == [:up, :down] ->
        "|"

      true ->
        IO.inspect({dir, {x, y}})
        raise "???"
    end
  end

  # go clockwise
  def trav_cw_and_add_insides(loop, d_map, curr, start, direction, points \\ []) do
    next_direction = get_next_direction(curr, d_map, direction)
    points = points ++ get_inside_positions(curr, direction, next_direction)
    next_pos = get_next_pos(curr, next_direction)

    cond do
      next_pos == start ->
        points

      true ->
        trav_cw_and_add_insides(
          loop,
          d_map,
          next_pos,
          start,
          next_direction,
          points
        )
    end
  end

  def get_next_direction(pos, d_map, direction) do
    tile =
      get_tile_at(d_map, pos)

    tile
    |> case do
      "F" when direction == :up ->
        :right

      "F" when direction == :left ->
        :down

      "7" when direction == :up ->
        :left

      "7" when direction == :right ->
        :down

      "L" when direction == :down ->
        :right

      "L" when direction == :left ->
        :up

      "J" when direction == :down ->
        :left

      "J" when direction == :right ->
        :up

      "|" ->
        direction

      "-" ->
        direction

      e ->
        IO.inspect(pos)
        IO.inspect(e)
        IO.inspect(direction)
        raise "wtf"
    end
  end

  def get_inside_positions(pos, prev_dir, curr_dir) do
    case {prev_dir, curr_dir} do
      {:up, :right} -> get_inner_positions(pos, :tl, false)
      {:left, :down} -> get_inner_positions(pos, :tl, true)
      {:right, :down} -> get_inner_positions(pos, :tr, false)
      {:up, :left} -> get_inner_positions(pos, :tr, true)
      {:down, :right} -> get_inner_positions(pos, :bl, true)
      {:left, :up} -> get_inner_positions(pos, :bl, false)
      {:down, :left} -> get_inner_positions(pos, :br, false)
      {:right, :up} -> get_inner_positions(pos, :br, true)
      _ -> []
    end
  end

  # :tl | :tr | :br | :bl
  def get_inner_positions({x, y}, corner, false) do
    case corner do
      :tl -> [{x + 1, y + 1}]
      :tr -> [{x - 1, y + 1}]
      :br -> [{x - 1, y - 1}]
      :bl -> [{x + 1, y - 1}]
    end
  end

  def get_inner_positions({x, y}, corner, true) do
    case corner do
      # o o o
      # o F -
      # o | x
      :tl -> [{x + 1, y - 1}, {x, y - 1}, {x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1}]
      # o o o
      # - 7 o
      # x | o
      :tr -> [{x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1}, {x + 1, y}, {x + 1, y + 1}]
      # x | o
      # - J o
      # o o o
      :br -> [{x + 1, y - 1}, {x + 1, y}, {x + 1, y + 1}, {x, y + 1}, {x - 1, y + 1}]
      # o | x
      # o L -
      # o o o
      :bl -> [{x + 1, y + 1}, {x, y + 1}, {x - 1, y + 1}, {x - 1, y}, {x - 1, y - 1}]
    end
  end

  def get_next_pos({x, y}, direction) do
    case direction do
      :up -> {x, y - 1}
      :right -> {x + 1, y}
      :down -> {x, y + 1}
      :left -> {x - 1, y}
    end
  end
end
