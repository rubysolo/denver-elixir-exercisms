defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t], pos_integer) :: map
  def frequency([], _), do: %{}

  def frequency(texts, workers) do
    combined_text = texts
    |> Enum.join()

    character_count = String.length(combined_text)
    chunk_size = div (character_count + workers - 1), workers

    combined_text
    |> String.split("", trim: true)
    |> Enum.chunk(chunk_size, chunk_size, [])
    |> Enum.map(&Enum.join/1)
    |> Enum.map(fn chunk ->
      Task.async(fn -> Frequency.Worker.start(self(), chunk) end)
    end)
    |> Enum.map(&Task.await/1)
    |> Enum.reduce(%{}, fn char_counts, acc ->
      Map.merge(acc, char_counts, fn _key, left, right ->
        left + right
      end)
    end)
  end

  # def give_work([], acc, workers) do
  #   Enum.reduce(acc, fn char_counts, acc ->
  #     Map.merge(acc, char_counts, fn _key, left, right ->
  #       left + right
  #     end)
  #   end)
  # end

  # def give_work([next_chunk|rest], acc, workers) do
  #   receive do
  #     {:done, pid} -> send pid, {:process, self(), next_chunk}
  #     give_work(rest, workers)
  #   end
  # end

  defmodule Worker do
    def start(caller, string) do
      count_codepoints(string)
    end

    def count_codepoints(string) do
      Regex.replace(~r{\W+|\d+}u, string, "")
      |> String.downcase()
      |> String.codepoints()
      |> Enum.reduce(%{}, fn char, acc ->
        if char != " " do
          {_, new_acc} = Map.get_and_update(acc, char, fn current ->
            {current, (current || 0) + 1}
          end)

          new_acc
        else
          acc
        end
      end)
    end
  end
end
