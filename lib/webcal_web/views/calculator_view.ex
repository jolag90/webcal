defmodule WebcalWeb.CalculatorView do
  use WebcalWeb, :view

  def pid_of(p1, p2, p3) do
    :c.pid(String.to_integer(p1), String.to_integer(p2), String.to_integer(p3))
  end
end
