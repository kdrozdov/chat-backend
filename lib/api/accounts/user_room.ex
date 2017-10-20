defmodule Api.Accounts.UserRoom do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Accounts.UserRoom

  schema "user_rooms" do
    belongs_to :user, Api.Accounts.User
    belongs_to :room, Api.Chat.Room

    timestamps()
  end

  @doc false
  def changeset(%UserRoom{} = user_room, attrs) do
    user_room
    |> cast(attrs, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
    |> unique_constraint(:user_id, name: :user_id_room_id)
  end
end
