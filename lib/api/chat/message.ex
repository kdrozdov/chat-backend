defmodule Api.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Chat.Message


  schema "messages" do
    field :text, :string
    belongs_to :room, Api.Chat.Room
    belongs_to :user, Api.Accounts.User


    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:text, :user_id, :room_id])
    |> validate_required([:text, :user_id, :room_id])
  end
end
