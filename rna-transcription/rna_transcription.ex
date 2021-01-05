defmodule RnaTranscription do
  [
    {'G', ?C},
    {'C', ?G},
    {'T', ?A},
    {'A', ?U},
  ]
  |> Enum.each(fn {k, v} ->
    # this is *kinda* like string interpolation:
    # "defp transcribe(#{k}), do: #{v}"
    defp transcribe(unquote(k)), do: unquote(v)
  end)

  def to_rna(dna) do
    Enum.map(dna, &transcribe/1)
  end

  # [?a, ?b, ?c] == 'abc'
  # [?a] == 'a'
end
