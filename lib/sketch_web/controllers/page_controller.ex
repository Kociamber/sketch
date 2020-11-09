defmodule SketchWeb.PageController do
  use SketchWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
