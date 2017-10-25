defmodule ApiWeb.RoomChannel do
  use ApiWeb, :channel
  alias Api.Services.Messages.GroupByDate

  def join("rooms:" <> room_id, _params, socket) do
    room = Api.Chat.get_room!(room_id)
    page = Api.Chat.room_messages(room.id)
    grouped_messages = GroupByDate.process(page.entries)

    response = %{
      room: Phoenix.View.render_one(room, ApiWeb.RoomView, "room.json"),
      messages: ApiWeb.MessageView.render_grouped(grouped_messages, %{}),
      pagination: ApiWeb.PaginationHelpers.pagination(page)
    }

    {:ok, response, assign(socket, :room, room)}
  end


  def handle_in("new_message", params, socket) do
    user = socket.assigns.current_user
    room = socket.assigns.room

    case Api.Chat.create_message(room, user, params) do
      {:ok, message} ->
        broadcast_message(socket, message)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, Phoenix.View.render(ApiWeb.ChangesetView, "error.json", changeset: changeset)}, socket}
    end
  end

  def terminate(_reason, socket) do
    {:ok, socket}
  end

  defp broadcast_message(socket, message) do
    message = Api.Repo.preload(message, :user)
    rendered_message = Phoenix.View.render_one(message, ApiWeb.MessageView, "message.json")
    broadcast!(socket, "message_created", rendered_message)
  end
end
