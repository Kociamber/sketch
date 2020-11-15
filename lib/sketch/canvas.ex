defmodule Sketch.Canvas do
  @moduledoc """
  Queue based Flood-Fill (Forest Fire) recursive algorithm implementation (https://en.wikipedia.org/wiki/Flood_fill).
  """
  @canvas_row_size Application.get_env(:sketch, :default_canvas_size, 32)
  @canvas_column_size Application.get_env(:sketch, :default_canvas_size, 12)

  @doc """
  Generates map type based canvas representation of the following structure:
  ```elixir
  %{
    0 => %{0 => "", 1 => "", 2 => "", 3 => "", 4 => ""},
    1 => %{0 => "", 1 => "", 2 => "", 3 => "", 4 => ""},
    2 => %{0 => "", 1 => "", 2 => "", 3 => "", 4 => ""},
    3 => %{0 => "", 1 => "", 2 => "", 3 => "", 4 => ""},
    4 => %{0 => "", 1 => "", 2 => "", 3 => "", 4 => ""}
  }
  ```
  Each key contains an index of y-axis position and its value is another map storing x-axis indexes
  along with a character (an empty string by default).
  This approach allows to leverage Elixir’s access behaviour - each element of the canvas can be
  dynamically accessed with `canvas[y][x]` syntax. For example: `put_in(canvas[y][x], "$")`

  ## Examples

      iex> new()
      %{0 => %{...}}}

  """
  @spec new() :: map()
  def new() do
    Enum.reduce(0..(@canvas_column_size - 1), %{}, fn y, acc ->
      Map.put(acc, y, create_canvas_x_axis())
    end)
  end

  defp create_canvas_x_axis() do
    Enum.reduce(0..(@canvas_row_size - 1), %{}, fn x, acc ->
      Map.put(acc, x, "")
    end)
  end
end
