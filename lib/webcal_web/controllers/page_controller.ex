defmodule WebcalWeb.PageController do
  use WebcalWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
