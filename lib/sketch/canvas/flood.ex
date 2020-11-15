defmodule Sketch.Canvas.Flood do
  @moduledoc """
  Queue based Flood-Fill (Forest Fire) recursive algorithm implementation (https://en.wikipedia.org/wiki/Flood_fill).
  """

  @doc """
  Fills canvas as per provided params.

  ## Examples

      iex> canvas = Sketch.Canvas.new()
      %{0 => %{...}}}
      fill(canvas, 1, 2, "#")
      %{0 => %{...}}}

  """
  @spec fill(map(), integer(), integer(), String.t()) :: map()
  def fill(canvas, x, y, fill_char) do
    queue = :queue.new()
    queue = :queue.in({x, y}, queue)
    flood_fill(canvas, fill_char, canvas[y][x], :queue.out(queue))
  end

  defp flood_fill(canvas, fill_char, target_char, _) when fill_char == target_char, do: canvas
  defp flood_fill(canvas, _fill_char, _target_char, {:empty, _}), do: canvas

  defp flood_fill(canvas, fill_char, target_char, {{:value, queue_head}, queue}) do
    {x, y} = queue_head

    {canvas, queue} =
      if canvas[y][x] == target_char do
        canvas = put_in(canvas[y][x], fill_char)
        # position on the left from the changed char
        queue = :queue.in({x - 1, y}, queue)
        # position on the right from the changed char
        queue = :queue.in({x + 1, y}, queue)
        # position above the changed char
        queue = :queue.in({x, y + 1}, queue)
        # position below the changed char
        queue = :queue.in({x, y - 1}, queue)
        {canvas, queue}
      else
        {canvas, queue}
      end

    flood_fill(canvas, fill_char, target_char, :queue.out(queue))
  end
end
