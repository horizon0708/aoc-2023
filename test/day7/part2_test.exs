defmodule Day7.Part2Test do
  use ExUnit.Case
  doctest Day7.Part2
  alias Day7.Input
  alias Day7.Part2

  test "run input" do
    res =
      Input.get()
      |> Part2.run()

    assert res == 251_037_509
  end

  test "run sample" do
    res =
      """
      32T3K 765
      T55J5 684
      KK677 28
      KTJJT 220
      QQQJA 483
      """
      |> Part2.run()

    assert res == 5905
  end

  test "run edge2" do
    res =
      """
      AAAAA 2
      22222 3
      AAAAK 5
      22223 7
      AAAKK 11
      22233 13
      AAAKQ 17
      22234 19
      AAKKQ 23
      22334 29
      AAKQJ 31
      22345 37
      AKQJT 41
      23456 43
      """
      |> Part2.run()

    assert res == 1369
  end

  test "run edge3" do
    res =
      """
      23456 22
      56789 19
      KJJKK 2
      AAAAJ 3
      JJ243 7
      QJ256 6
      QQ562 5
      Q8Q24 4
      AAAAT 3
      TJJJJ 2
      6789T 18
      789TJ 17
      22345 13
      34567 21
      45678 20
      32245 12
      33245 11
      89TJQ 16
      9TJQK 15
      TJQKA 14
      3J245 10
      J3425 9
      J5432 8
      JJJJJ 1
      """
      |> Part2.run()

    assert res == 2297
  end
end
