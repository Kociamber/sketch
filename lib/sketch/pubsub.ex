defmodule Sketch.PubSub do
  @moduledoc """
  Provides basic PubSup API for drawing operations and LiveView updates.
  """
  def topic, do: "canvas.updates"

  def subscribe_to_update_notifications(),
    do: Phoenix.PubSub.subscribe(Sketch.PubSub, topic())

  def subscribe_to_update_notifications(id),
    do: Phoenix.PubSub.subscribe(Sketch.PubSub, topic() <> ":" <> id)

  def broadcast_update_notification(),
    do: Phoenix.PubSub.broadcast(Sketch.PubSub, topic(), :canvas_update)

  def broadcast_update_notification(id),
    do: Phoenix.PubSub.broadcast(Sketch.PubSub, topic() <> ":" <> id, :canvas_update)
end
