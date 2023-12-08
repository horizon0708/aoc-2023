defmodule Day7.Part1Test do
  use ExUnit.Case
  doctest Day7.Part1
  alias Day7.Input
  alias Day7.Rule
  alias Day7.Part1
  alias Day7.Parser

  @sample """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """

  test "run input" do
    res =
      Input.get()
      |> Part1.run()
      |> IO.inspect()

    assert res == 250_602_641
  end

  test "run sample" do
    res =
      @sample
      |> Part1.run()

    assert res == 6440
  end

  test "run sample 2" do
    res =
      Input.get_test()
      |> Part1.run()

    assert res == 635_206
  end

  test "run edge" do
    res =
      """
      2345A 1
      Q2KJJ 13
      Q2Q2Q 19
      T3T3J 17
      T3Q33 11
      2345J 3
      J345A 2
      32T3K 5
      T55J5 29
      KK677 7
      KTJJT 34
      QQQJA 31
      JJJJJ 37
      JAAAA 43
      AAAAJ 59
      AAAAA 61
      2AAAA 23
      2JJJJ 53
      JJJJ2 41
      """
      |> Part1.run()
      |> IO.inspect()

    assert res == 6592
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
      |> Part1.run()
      |> IO.inspect()

    assert res == 1343
  end

  test "parse_input/1" do
    res =
      @sample
      |> Parser.from()

    assert res == [
             {[3, 2, 10, 3, 13], 765},
             {[10, 5, 5, 11, 5], 684},
             {[13, 13, 6, 7, 7], 28},
             {[13, 10, 11, 11, 10], 220},
             {[12, 12, 12, 11, 14], 483}
           ]
  end

  test "get_type/1" do
    res =
      [
        {[3, 2, 10, 3, 13], 765},
        {[10, 5, 5, 11, 5], 684},
        {[13, 13, 6, 7, 7], 28},
        {[13, 10, 11, 11, 10], 220},
        {[12, 12, 12, 11, 14], 483}
      ]
      |> Enum.map(&elem(&1, 0))
      |> Enum.map(&Rule.get_type/1)

    assert res == [2, 4, 3, 3, 4]
  end

  test "sort/1" do
    res =
      [
        {[3, 2, 10, 3, 13], 765},
        {[10, 5, 5, 11, 5], 684},
        {[13, 13, 6, 7, 7], 28},
        {[13, 10, 11, 11, 10], 220},
        {[12, 12, 12, 11, 14], 483}
      ]
      |> Enum.map(&Rule.calculate_strength/1)
      |> Rule.sort()
      |> Enum.map(&elem(&1, 2))
      |> Enum.map(&elem(&1, 0))

    # |> IO.inspect(charlists: :as_list)

    assert res == [
             [3, 2, 10, 3, 13],
             [13, 10, 11, 11, 10],
             [13, 13, 6, 7, 7],
             [10, 5, 5, 11, 5],
             [12, 12, 12, 11, 14]
           ]
  end
end
