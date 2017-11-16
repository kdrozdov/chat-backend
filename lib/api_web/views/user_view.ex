defmodule ApiWeb.UserView do
  use ApiWeb, :view
  alias Api.Services.Md5

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email_hash: user.email |> Md5.process,
    }
  end
end
