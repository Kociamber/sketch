defmodule SketchWeb.PageLive do
  use SketchWeb, :live_view
  alias Sketch.PubSub

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe_to_update_notifications()
    {:ok, assign(socket, canvas_list: Sketch.Storage.list())}
  end

  @impl true
  def handle_info(:canvas_update, socket),
    do: {:noreply, assign(socket, canvas_list: Sketch.Storage.list())}
end
