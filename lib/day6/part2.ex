defmodule Day6.Part2 do
  def run({time, _} = race) do
    opts = [
      race: race,
      step: floor(time / 2)
    ]

    upper_bound = search_boundary(nil, 0, Keyword.put(opts, :search_for, :upper))
    lower_bound = search_boundary(nil, time, Keyword.put(opts, :search_for, :lower))

    upper_bound - lower_bound + 1
  end

  def search_boundary({won?, prev}, curr, opts) do
    race = Keyword.get(opts, :race)
    search_for = Keyword.get(opts, :search_for)
    step = Keyword.get(opts, :step)

    # this shouldn't happen depending on results but I cbf
    new_step = max(floor(step / 2), 1)

    opts = Keyword.put(opts, :step, new_step)

    case {won?, wins?(curr, race), curr - prev} do
      {true, false, 1} when search_for == :upper ->
        prev

      {true, false, -1} when search_for == :lower ->
        prev

      {pw, cw, _} ->
        direction = get_direction(pw, pw, search_for)
        search_boundary({cw, curr}, curr + new_step * direction, opts)
    end
  end

  def search_boundary(nil, curr, opts) do
    race = Keyword.get(opts, :race)
    search_for = Keyword.get(opts, :search_for, :lower)
    step = Keyword.get(opts, :step)
    curr_result = wins?(curr, race)

    case search_for do
      :lower -> search_boundary({curr_result, curr}, curr - step, opts)
      :upper -> search_boundary({curr_result, curr}, curr + step, opts)
    end
  end

  def get_direction(prev, curr, search_for) do
    # movement based finding lower bound
    case {prev, curr} do
      {true, true} -> -1
      {true, false} -> 1
      {false, true} -> -1
      {false, false} -> 1
    end
    |> then(fn direction ->
      # flip for upper bound
      case search_for do
        :upper -> direction * -1
        :lower -> direction
      end
    end)
  end

  def wins?(speed, {time, distance}) do
    remaining = time - speed
    remaining * speed > distance
  end
end
