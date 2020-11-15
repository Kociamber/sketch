defmodule Sketch.Seeds.Canvas do
  @moduledoc false
  alias Sketch.Canvas
  alias Sketch.Canvas.{Rectangle, Flood}
  @on_load {:create_sample_canvas, 0}
  def create_sample_canvas() do
    canvas =
      Canvas.new()
      # Rectangle at `[14, 0]` with width `7`, height `6`, outline character: none, fill: `.`
      |> Rectangle.draw(14, 0, 7, 6, nil, ".")
      # Rectangle at `[0, 3]` with width `8`, height `4`, outline character: `O`, fill: `none`
      |> Rectangle.draw(0, 3, 8, 4, "O", nil)
      # Rectangle at `[5, 5]` with width `5`, height `3`, outline character: `X`, fill: `X`
      |> Rectangle.draw(5, 5, 5, 3, "X", "X")
      # Flood fill at `[0, 0]` with fill character `-` (canvas presented in 32x12 size)
      |> Flood.fill(0, 0, "-")

    Sketch.Storage.create(canvas)
  end
end
