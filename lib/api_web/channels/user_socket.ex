defmodule ApiWeb.UserSocket do
  use Phoenix.Socket

  transport :websocket, Phoenix.Transports.WebSocket, timeout: 45_000
  channel "rooms:*", ApiWeb.RoomChannel

  def connect(%{"token" => token}, socket) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        case Api.Serializers.GuardianSerializer.from_token(claims["sub"]) do
          {:ok, user} ->
            {:ok, assign(socket, :current_user, user)}
          {:error, _reason} ->
            :error
        end
      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error

  def id(socket), do: "users_socket:#{socket.assigns.current_user.id}"
end
