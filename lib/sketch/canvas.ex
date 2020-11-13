defmodule Sketch.Canvas do
  @canvas_row_size Application.get_env(:sketch, :default_canvas_size, 32)
  @canvas_column_size Application.get_env(:sketch, :default_canvas_size, 12)

  # Generates a map based canvas of following structure:
  # %{
  #   0 => %{0 => "", 1 => "", 2 => "", 3 => "", 4 => ""},
  #   1 => %{0 => "", 1 => "", 2 => "", 3 => "", 4 => ""},
  #   2 => %{0 => "", 1 => "", 2 => "", 3 => "", 4 => ""},
  #   3 => %{0 => "", 1 => "", 2 => "", 3 => "", 4 => ""},
  #   4 => %{0 => "", 1 => "", 2 => "", 3 => "", 4 => ""}
  # }
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
