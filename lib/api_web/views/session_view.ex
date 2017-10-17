defmodule ApiWeb.SessionView do
  use ApiWeb, :view

  def render("show.json", %{user: user, jwt: jwt}) do
    %{
      data: render_one(user, ApiWeb.UserView, "user.json"),
      meta: %{token: jwt}
    }
  end

  def render("error.json", _) do
    %{errors: %{detail: "Invalid email or password"}}
  end

  def render("delete.json", _) do
    %{ok: true}
  end

  def render("forbidden.json", %{error: error}) do
    %{errors: %{detail: error}}
  end
end
