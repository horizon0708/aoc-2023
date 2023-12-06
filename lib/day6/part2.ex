defmodule Day6.Part2 do
  def run({time, _} = race) do
    opts = [
      race: race,
      step: floor(time / 2)
    ]

    upper_bound = search_boundary(0, nil, Keyword.put(opts, :direction, :upper))
    lower_bound = search_boundary(time, nil, Keyword.put(opts, :direction, :lower))

    upper_bound - lower_bound + 1
  end

  def search_boundary(curr, {won?, prev}, opts) do
    race = Keyword.get(opts, :race)
    direction = Keyword.get(opts, :direction, :lower)
    step = Keyword.get(opts, :step)
    new_step = max(floor(step / 2), 1)

    opts = Keyword.put(opts, :step, new_step)

    case {won?, wins?(curr, race), curr - prev} do
      {true, false, 1} when direction == :upper -> prev
      {true, false, -1} when direction == :lower -> prev
      {p, cw, _} -> {cw, build_move(p, cw, direction)}
    end
    |> case do
      {cw, op} -> search_boundary(op.(curr, new_step), {cw, curr}, opts)
      el -> el
    end
  end

  def search_boundary(curr, nil, opts) do
    race = Keyword.get(opts, :race)
    direction = Keyword.get(opts, :direction, :lower)
    step = Keyword.get(opts, :step)

    case direction do
      :lower -> search_boundary(curr - step, {wins?(curr, race), curr}, opts)
      :upper -> search_boundary(curr + step, {wins?(curr, race), curr}, opts)
    end
  end

  def build_move(prev, curr, search_direction) do
    # movement based finding lower bound
    up? =
      case {prev, curr} do
        {true, true} -> false
        {true, false} -> true
        {false, true} -> false
        {false, false} -> true
      end

    up? = if search_direction == :upper, do: not up?, else: up?

    case up? do
      true -> &Kernel.+/2
      false -> &Kernel.-/2
    end
  end

  def wins?(speed, {time, distance}) do
    remaining = time - speed
    remaining * speed > distance
  end
end
