defmodule ApiWeb.MessageController do
  use ApiWeb, :controller

  alias Api.Chat
  alias Api.Services.Messages.GroupByDate

  plug Guardian.Plug.EnsureAuthenticated, handler: ApiWeb.SessionController
  action_fallback ApiWeb.FallbackController

  def index(conn, params) do
    last_seen_id = params["last_seen_id"] || 0
    room = Chat.get_room!(params["room_id"])
    page = Api.Chat.previous_messages(room.id, last_seen_id)
    grouped_messages = GroupByDate.process(page.entries)

    render(conn, "index.json", %{messages: grouped_messages, pagination: ApiWeb.PaginationHelpers.pagination(page)})
  end
end
