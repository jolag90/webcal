defmodule WebcalWeb.UserController do
  use WebcalWeb, :controller

  def new_session(conn, _params) do
    render(conn, "new_session.html")
  end

  def start_session(conn, %{"user" => %{"username" => username}}) do
    calculator_name = String.to_atom(username)

    case Calculator.start_link(calculator_name) do
      {:ok, pid} ->
        [p1, p2, p3] = pid_to_string(pid)
        redirect(conn, to: "/cal/#{p1}/#{p2}/#{p3}")

      {:error, {:already_started, pid}} ->
        [p1, p2, p3] = pid_to_string(pid)
        redirect(conn, to: "/cal/#{p1}/#{p2}/#{p3}")

      {:error, err} ->
        IO.inspect(err, label: "ERROR")
        render(conn, "new_session.html")
    end
  end

  defp pid_to_string(pid) do
    [_, p] =
      inspect(pid)
      |> String.trim(">")
      |> String.split("<")

    [_p1, _p2, _p3] = String.split(p, ".")
  end
end
