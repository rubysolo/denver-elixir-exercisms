defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @day_numbers %{
    :monday => 1,
    :tuesday => 2,
    :wednesday => 3,
    :thursday => 4,
    :friday => 5,
    :saturday => 6,
    :sunday => 7,
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, :last) do
    {:ok, d} = Date.new(year, month, 1)
    last_day = Date.days_in_month(d)

    (last_day - 6)..last_day
    |> find_matching_day(year, month, Map.get(@day_numbers, weekday))
  end

  def meetup(year, month, weekday, schedule) do
    schedule
    |> range_for_schedule
    |> find_matching_day(year, month, Map.get(@day_numbers, weekday))
  end

  defp find_matching_day(range, year, month, weekday) do
    first_match =
      range
      |> Enum.find(fn day ->
        {:ok, d} = Date.new(year, month, day)
        Date.day_of_week(d) == weekday
      end)

    {year, month, first_match}
  end

  defp range_for_schedule(:teenth), do: 13..19
  defp range_for_schedule(:first), do: 1..7
  defp range_for_schedule(:second), do: 8..14
  defp range_for_schedule(:third), do: 15..21
  defp range_for_schedule(:fourth), do: 22..28
end
