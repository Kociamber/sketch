defmodule SketchWeb.CanvasControllerTest do
  use SketchWeb.ConnCase

  alias Sketch.Canvas
  alias Sketch.Canvas.{Rectangle, Flood}

  @update_attrs %{operation: "rectangle", x: 1, y: 2, width: 5, height: 5, fill_char: "#"}
  @invalid_attrs %{operation: "flood", x: 0, y: 2, fill_char: "kiełbasa"}

  setup %{conn: conn} do
    # clear test env DETS file
    File.rm("sketch_storage_test")
    # generate test canvas with few drawing operations applied
    canvas = create_test_canvas()
    on_exit(fn -> File.rm("sketch_storage_test") end)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), canvas: canvas}
  end

  describe "index" do
    test "lists all canvases", %{conn: conn, canvas: canvas} do
      conn = get(conn, Routes.canvas_path(conn, :index))
      assert json_response(conn, 200)["canvases"] == [canvas]
    end
  end

  test "create and render", %{conn: conn} do
    conn = post(conn, Routes.canvas_path(conn, :create))
    json_response(conn, 201)["canvas"]
    assert %{"id" => id, "content" => content} = json_response(conn, 201)["canvas"]

    conn = get(conn, Routes.canvas_path(conn, :show, id))

    assert %{
             "id" => ^id,
             "content" => ^content
           } = json_response(conn, 200)["canvas"]
  end

  describe "update canvas" do
    test "renders canvas when data is valid", %{conn: conn, canvas: %{"id" => id}} do
      conn = put(conn, Routes.canvas_path(conn, :update, id), @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["canvas"]

      conn = get(conn, Routes.canvas_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "content" => %{}
             } = json_response(conn, 200)["canvas"]
    end

    test "renders errors when data is invalid", %{conn: conn, canvas: %{"id" => id}} do
      conn = put(conn, Routes.canvas_path(conn, :update, id), @invalid_attrs)

      assert json_response(conn, 400)["error"] == "bad request"
    end
  end

  describe "delete canvas" do
    test "deletes chosen canvas", %{conn: conn, canvas: %{"id" => id}} do
      conn = delete(conn, Routes.canvas_path(conn, :delete, id))
      assert response(conn, 204)

      conn = get(conn, Routes.canvas_path(conn, :show, id))
      assert json_response(conn, 404)["error"] == "not found"
    end
  end

  defp create_test_canvas() do
    {:ok, canvas} =
      Canvas.new()
      # Rectangle at `[14, 0]` with width `7`, height `6`, outline character: none, fill: `.`
      |> Rectangle.draw(14, 0, 7, 6, nil, ".")
      # Rectangle at `[0, 3]` with width `8`, height `4`, outline character: `O`, fill: `none`
      |> Rectangle.draw(0, 3, 8, 4, "O", nil)
      # Rectangle at `[5, 5]` with width `5`, height `3`, outline character: `X`, fill: `X`
      |> Rectangle.draw(5, 5, 5, 3, "X", "X")
      # Flood fill at `[0, 0]` with fill character `-` (canvas presented in 32x12 size)
      |> Flood.fill(0, 0, "-")
      |> Sketch.Storage.create()

    # transform all numeric keys to strings in order to match the canvas map with the response
    new_content =
      Enum.into(canvas[:content], %{}, fn {k, v} ->
        {to_string(k), Enum.into(v, %{}, fn {k, v} -> {to_string(k), v} end)}
      end)

    Map.merge(%{"id" => canvas[:id]}, %{"content" => new_content})
  end
end
