defmodule SketchWeb.Router do
  use SketchWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SketchWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SketchWeb do
    pipe_through :browser

    live "/", PageLive
    live "/:id", CanvasLive
  end

  scope "/api", SketchWeb do
    pipe_through :api

    get "/canvas", CanvasController, :index
    get "/canvas/:id", CanvasController, :show
    put "/canvas/:id", CanvasController, :update
    post "/canvas", CanvasController, :create
    delete "/canvas/:id", CanvasController, :delete
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: SketchWeb.Telemetry
    end
  end
end
