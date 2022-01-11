defmodule WebcalWeb.CalculatorController do
  use WebcalWeb, :controller

  def index(conn, %{"p1" => p1, "p2" => p2, "p3" => p3}) do
    render(conn, "index.html", p1: p1, p2: p2, p3: p3)
  end

  def key(conn, %{"p1" => p1, "p2" => p2, "p3" => p3, "key" => key}) do
    key =
      case key do
        ":" -> "/"
        "," -> "."
        k -> k
      end

    WebcalWeb.CalculatorView.pid_of(p1, p2, p3)
    |> Calculator.press_key(key)

    render(conn, "index.html", p1: p1, p2: p2, p3: p3)
  end
end
