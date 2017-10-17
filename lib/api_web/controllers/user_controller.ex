defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.User

  action_fallback ApiWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      new_conn = Guardian.Plug.api_sign_in(conn, user, :access)
      jwt = Guardian.Plug.current_token(new_conn)

      new_conn
      |> put_status(:created)
      |> render(ApiWeb.SessionView, "show.json", user: user, jwt: jwt)
    end
  end
end
