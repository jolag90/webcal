defmodule WebcalWeb.PageControllerTest do
  use WebcalWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Calculator"
  end
end
