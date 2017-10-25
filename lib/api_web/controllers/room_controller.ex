defmodule ApiWeb.RoomController do
  use ApiWeb, :controller

  alias Api.Chat
  alias Api.Chat.Room
  alias Api.Accounts

  plug Guardian.Plug.EnsureAuthenticated, handler: ApiWeb.SessionController
  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    rooms = Chat.list_rooms()
    render(conn, "index.json", rooms: rooms)
  end

  def create(conn, %{"room" => room_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    with {:ok, %Room{} = room} <- Chat.create_room(room_params) do
      Accounts.create_user_room(%{
        user_id: current_user.id,
        room_id: room.id
      })

      conn
      |> put_status(:created)
      |> render("show.json", room: room)
    end
  end

  def join(conn, %{"id" => room_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    room = Chat.get_room!(room_id)
    params = %{room_id: room.id, user_id: current_user.id}

    with {:ok, _} <- Accounts.create_user_room(params) do
      conn
        |> put_status(:created)
        |> render("show.json", %{room: room})

    end
  end
end
