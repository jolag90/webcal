defmodule WebcalWeb.WelcomeController do
  use WebcalWeb, :controller

  def servus(conn, %{"name" => name}) do
    welcome = "Hello, #{String.upcase(name)}"
    render(conn, "servus.html", welcome: welcome)
  end
  def stranger(conn, _param) do
    render(conn, "stranger.html")
  end
end
