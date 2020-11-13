defmodule SketchWeb.CanvasController do
  use SketchWeb, :controller
  alias Sketch.Storage
  alias Sketch.Canvas
  alias Sketch.Canvas.{Flood, Rectangle}
  action_fallback SketchWeb.FallbackController

  @canvas_row_size Application.get_env(:sketch, :default_canvas_size, 32)
  @canvas_column_size Application.get_env(:sketch, :default_canvas_size, 12)

  def index(conn, _params) do
    canvases = Storage.list()
    render(conn, "index.json", canvases: canvases)
  end

  def create(conn, _params) do
    with {:ok, canvas} <- Storage.create(Canvas.new()) do
      conn
      |> put_status(:created)
      |> render("show.json", canvas: canvas)
    else
      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> put_view(SketchWeb.ErrorView)
        |> render("500.json", message: reason)
    end
  end

  def show(conn, %{"id" => id}) do
    canvas = Storage.get(id)
    render(conn, "show.json", canvas: canvas)
  end

  def update(conn, %{"id" => id, "operation" => operation} = params) do
    %{id: id, content: content} = Storage.get(id)

    IO.inspect(params, label: "params~~~")

    with true <- params_valid?(operation, params),
         content = perform_operation(operation, content, params),
         {:ok, canvas} <- Storage.update(id, content) do
      render(conn, "show.json", canvas: canvas)
    else
      false ->
        conn
        |> put_status(:bad_request)
        |> put_view(SketchWeb.ErrorView)
        |> render("400.json", message: "invalid or missing params")

      {:error, reason} ->
        conn
        |> put_view(SketchWeb.ErrorView)
        |> render("500.json", message: reason)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, _canvas} <- Storage.delete(id) do
      send_resp(conn, :no_content, "")
    else
      {:error, reason} ->
        conn
        |> put_view(SketchWeb.ErrorView)
        |> render("500.json", message: reason)
    end
  end

  defp params_valid?("flood", %{"x" => x, "y" => y, "fill_char" => fill_char}) do
    x in 0..(@canvas_row_size - 1) and y in 0..(@canvas_column_size - 1) and
      String.length(fill_char) == 1
  end

  defp params_valid?(
         "rectangle",
         %{"x" => x, "y" => y, "width" => width, "height" => height} = params
       ) do
    x in 0..(@canvas_row_size - 1) and y in 0..(@canvas_column_size - 1) and
      width > 0 and height > 0 and characters_valid?(params["outline_char"], params["fill_char"])
  end

  defp params_valid?(_operation, _params), do: false

  defp characters_valid?(nil, nil), do: false
  defp characters_valid?(nil, fill_char), do: String.length(fill_char) == 1
  defp characters_valid?(outline_char, nil), do: String.length(outline_char) == 1

  defp characters_valid?(outline_char, fill_char),
    do: String.length(outline_char) == 1 and String.length(fill_char) == 1

  defp perform_operation("flood", canvas, %{"x" => x, "y" => y, "fill_char" => fill_char}),
    do: Flood.fill(canvas, x, y, fill_char)

  defp perform_operation(
         "rectangle",
         canvas,
         %{
           "x" => x,
           "y" => y,
           "width" => width,
           "height" => height
         } = params
       ),
       do:
         Rectangle.draw(canvas, x, y, width, height, params["outline_char"], params["fill_char"])
end
