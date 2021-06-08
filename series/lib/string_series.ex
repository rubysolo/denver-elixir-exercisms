defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(s, size) when size < 1 do
    []
  end

  # iteration 1
  # def slices(s, size) do
  #   s
  #   |> String.graphemes()
  #   |> Enum.chunk_every(size, 1, :discard)
  #   |> Enum.map(&Enum.join/1)
  # end

  # iteration 2
  def slices(s, size) do
    s
    |> Stream.unfold(fn
      <<first::utf8, rest::binary>> -> {<<first::utf8>>, rest}
      <<>> -> nil
    end)
    |> Stream.chunk_every(size, 1, :discard)
    |> Enum.map(&Enum.join/1)
  end

end
