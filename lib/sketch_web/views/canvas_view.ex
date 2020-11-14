defmodule SketchWeb.CanvasView do
  use SketchWeb, :view
  alias SketchWeb.CanvasView

  def render("index.json", %{canvases: canvases}) do
    %{canvases: render_many(canvases, CanvasView, "canvas.json")}
  end

  def render("show.json", %{canvas: canvas}) do
    %{canvas: render_one(canvas, CanvasView, "canvas.json")}
  end

  def render("canvas.json", %{canvas: canvas}) do
    %{id: canvas.id, content: canvas.content}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end
end
