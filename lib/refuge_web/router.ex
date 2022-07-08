defmodule RefugeWeb.Router do
  use RefugeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RefugeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RefugeWeb do
    pipe_through :browser

    # This macro "scope" generates the same thing as the below function:
    # def match(conn, "GET", ["/bears"]) do
    #   BearsController.index(conn)
    # end
    get "/", PageController, :index  # is the same as match/3 function above

    # get "/", PageController, :index
    # get "/bears", BearsController, :index
    # get "/bears/new", BearsController, :new
    # get "/bears/:id", BearsController, :show
    # get "/bears/:id/edit", BearsController, :edit
    # post "/bears", BearsController, :create
    # put "/bears/:id", BearsController, :update
    # patch "/bears/:id", BearsController, :update
    # delete "/bears/:id", BearsController, :delete

    # All the 8 operations above is the same as we define the macro `resources`:
    resources "/bears", BearController
  end


  # Other scopes may use custom stacks.
  # scope "/api", RefugeWeb do
  #   pipe_through :api
  # end

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

      live_dashboard "/dashboard", metrics: RefugeWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
