defmodule Utils do
  def to_integer!(b) when is_binary(b) do
    b
    |> String.trim()
    |> Integer.parse()
    |> case do
      {n, _} -> n
      _ -> raise "should be int! #{inspect(b)}"
    end
  end

  def to_integer!(b) when is_list(b) do
    Enum.map(b, &to_integer!/1)
  end
end
