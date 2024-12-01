defmodule Advent2024exWeb.ErrorJSONTest do
  use Advent2024exWeb.ConnCase, async: true

  test "renders 404" do
    assert Advent2024exWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Advent2024exWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
