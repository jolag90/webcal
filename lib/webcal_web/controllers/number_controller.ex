defmodule WebcalWeb.NumberController do
  use WebcalWeb, :controller
  def pi(conn, _param) do
    text(conn, "3,1415926535897932341978462")
  end
end
