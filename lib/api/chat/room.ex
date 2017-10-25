defmodule Api.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Chat.Room


  schema "rooms" do
    many_to_many :users, Api.Accounts.User, join_through: "user_rooms"
    has_many :messages, Api.Chat.Message
    field :name, :string
    field :topic, :string

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name, :topic])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
