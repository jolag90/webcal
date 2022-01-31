defmodule WebcalWeb.PageControllerTest do
  use WebcalWeb.ConnCase

  test "GET /lvcal", %{conn: conn} do
    conn = get(conn, "/lvcal")
    assert html_response(conn, 200) =~ "Calculator"
  end
end
