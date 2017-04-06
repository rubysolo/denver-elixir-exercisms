defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t) :: map()
  def count(sentence) do
    sentence
    |> String.replace(~r/,|_|!|&|@|\$|%|\^|&|:/, " ")
    |> String.split()
    |> Enum.map(&String.downcase/1)
    |> Enum.reduce(%{}, fn (s, acc) ->
      Map.update(acc, s, 1, &(&1 + 1))
    end)
  end
end
