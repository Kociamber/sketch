defmodule Sketch.Canvas.Rectangle do
  # NOTE: Because as per assignment - "The canvas can be assumed to be a fixed size".
  @canvas_row_size Application.get_env(:sketch, :default_canvas_size, 32)
  @canvas_column_size Application.get_env(:sketch, :default_canvas_size, 12)
  # Sketch.Canvas.Rectangle.draw(canvas, 1, 2, 2, 3, "%", "v")
  def draw(canvas, x, y, width, height, outline_char, fill_char) do
    if x < @canvas_row_size and y < @canvas_column_size do
      canvas = process_position(canvas, x, y, x, y, width, height, outline_char, fill_char)
      draw_row(canvas, x, y, width, height, outline_char, fill_char, x + 1, y)
    else
      canvas
    end
  end

  defp draw_row(canvas, x, y, width, height, outline_char, fill_char, i, j)
       when i == @canvas_row_size,
       do: draw_row(canvas, x, y, width, height, outline_char, fill_char, x, j + 1)

  defp draw_row(canvas, _x, _y, _width, _height, _outline_char, _fill_char, _i, j)
       when j == @canvas_column_size,
       do: canvas

  defp draw_row(canvas, _x, y, _width, height, _outline_char, _fill_char, _i, j)
       when j > y + height - 1,
       do: canvas

  defp draw_row(canvas, x, _y, width, _height, _outline_char, _fill_char, i, _j)
       when i > x + width - 1,
       do: canvas

  defp draw_row(canvas, x, y, width, height, outline_char, fill_char, i, j)
       when i == x + width - 1 do
    canvas
    |> process_position(x, y, i, j, width, height, outline_char, fill_char)
    |> draw_row(x, y, width, height, outline_char, fill_char, x, j + 1)
  end

  defp draw_row(canvas, x, y, width, height, outline_char, fill_char, i, j)
       when i < x + width - 1 do
    canvas
    |> process_position(x, y, i, j, width, height, outline_char, fill_char)
    |> draw_row(x, y, width, height, outline_char, fill_char, i + 1, j)
  end

  defp process_position(canvas, x, y, i, j, width, height, outline_char, fill_char) do
    cond do
      is_outline_position?(x, y, i, j, width, height) and outline_char == nil ->
        put_in(canvas[j][i], fill_char)

      is_outline_position?(x, y, i, j, width, height) ->
        put_in(canvas[j][i], outline_char)

      !is_outline_position?(x, y, i, j, width, height) and fill_char != nil ->
        put_in(canvas[j][i], fill_char)

      true ->
        canvas
    end
  end

  defp is_outline_position?(x, y, i, j, width, height),
    do: i == x or i == x + width - 1 or j == y or j == y + height - 1
end
