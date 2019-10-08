defmodule Matrix do
  defstruct [input: nil, rows: nil]

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    list =
      input
      |> String.split("\n")
      |> Enum.map(&parse_row/1)
    %Matrix{input: input, rows: list}
  end

  defp parse_row(line) do
    line
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(matrix) do
    matrix.input
  end

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(%Matrix{rows: rows}) do
    rows
  end

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  # def row(matrix, index) do
  #   Enum.at(matrix.rows, index)
  # end

  def row(%Matrix{rows: rows}, index) do
    Enum.at(rows, index)
  end

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  # def columns(%Matrix{rows: rows}) do
  #   for index <- 0..(length(rows) - 1), row <- rows do
  #     Enum.at(row, index)
  #   end
  #   |> Enum.chunk_every(length(rows))
  # end
  def columns(%Matrix{rows: [row|_rest]}=matrix) do
    width = length(row)
    0..(width - 1)
    |> Enum.map(fn index ->
      column(matrix, index)
    end)
  end

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(%Matrix{rows: rows}, index) do
    rows
    |> Enum.map(fn row ->
      Enum.at(row, index)
    end)
  end
end
