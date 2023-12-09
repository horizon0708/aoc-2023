defmodule Day7.Part2 do
  alias Day7.Part2.Rule
  alias Day7.Part2.Parser

  def run(text) do
    text
    |> Parser.from()
    |> Enum.map(&Rule.calculate_strength/1)
    |> Rule.sort()
    # |> IO.inspect(charlists: :as_list, limit: :infinity)
    |> Enum.map(&elem(&1, 2))
    |> Enum.map(&elem(&1, 1))
    |> Enum.with_index(1)
    # |> IO.inspect(charlists: :as_list, limit: :infinity)
    |> Enum.map(fn {score, ind} -> score * ind end)
    |> Enum.sum()
  end
end

defmodule Day7.Part2.Rule do
  def sort(hands) do
    hands
    |> Enum.sort_by(fn x -> x end, fn {a_type, a_hands, _}, {b_type, b_hands, _} ->
      if a_type == b_type do
        a_hands <= b_hands
      else
        a_type <= b_type
      end
    end)
  end

  def hand_score(hand) do
    hand
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {x, ind} -> x * :math.pow(15, ind) end)
    |> Enum.sum()
  end

  def calculate_strength({hand, score}) do
    {get_type(hand), hand_score(hand), {hand, score}}
  end

  def get_type(hand) do
    hand
    |> Enum.sort()
    |> Enum.chunk_by(fn n -> n end)
    |> Enum.sort_by(&length/1, :desc)
    |> case do
      # five of a kind???
      [[_, _, _, _, _]] ->
        7

      # four of a kind
      [[_, _, _, _] = a, b] ->
        cond do
          1 in a or 1 in b -> 6 + 1
          true -> 6
        end

      # fullhouse
      [[_, _, _] = a, [_, _] = b] ->
        5 + maybe_add(1 in a or 1 in b, 2)

      # three of a kind
      [[_, _, _] = a, b, c] ->
        r = a ++ b ++ c
        4 + maybe_add(1 in r, 2)

      # two pair
      [[_, _], [_, _], [1]] ->
        3 + 2

      [[_, _] = a, [_, _] = b, _] ->
        3 + maybe_add(1 in a or 1 in b, 3)

      # one pair
      [[_, _] = a, c1, c2, c3] ->
        r = c1 ++ c2 ++ c3

        cond do
          1 in a -> 2 + 2
          1 in r -> 2 + 2
          true -> 2
        end

      # high card
      e ->
        1 + maybe_add(1 in List.flatten(e), 1)
    end
  end

  def maybe_add(true, inc), do: inc
  def maybe_add(false, _inc), do: 0
end

defmodule Day7.Part2.Parser do
  def from(text) do
    text
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [hand, points] =
      line
      |> String.split(" ", trim: true)

    {parse_hand(hand), Utils.to_integer!(points)}
  end

  def parse_hand(hand) do
    hand
    |> String.codepoints()
    |> Enum.map(&map_to_strength/1)
  end

  defp map_to_strength(letter) do
    case letter do
      "A" -> 14
      "K" -> 13
      "Q" -> 12
      "J" -> 1
      "T" -> 10
      n -> Utils.to_integer!(n)
    end
  end
end
