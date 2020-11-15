defmodule SketchWeb.CanvasLive do
  use SketchWeb, :live_view
  alias Sketch.PubSub

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    PubSub.subscribe_to_update_notifications(id)
    {:ok, assign(socket, canvas: Sketch.Storage.get(id))}
  end

  @impl true
  def handle_info(:canvas_update, socket) do
    id =
      socket
      |> Map.get(:assigns)
      |> Map.get(:canvas)
      |> Map.get(:id)

    {:noreply, assign(socket, canvas: Sketch.Storage.get(id))}
  end
end
