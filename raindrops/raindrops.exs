defmodule Raindrops do
  @factors [
    {7, "Plong"},
    {5, "Plang"},
    {3, "Pling"},
  ]

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t
  def convert(number) do
    labeled = Enum.reduce(@factors, [], fn({factor, label}, acc) ->
      new_label = if rem(number, factor) == 0, do: label, else: ""
      [new_label | acc]
    end)
    |> Enum.join()

    if labeled == "" do
      Integer.to_string(number)
    else
      labeled
    end
  end
end
