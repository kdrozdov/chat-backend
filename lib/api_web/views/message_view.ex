defmodule ApiWeb.MessageView do
  use ApiWeb, :view
  alias ApiWeb.MessageView

  def render("index.json", %{messages: messages, pagination: pagination}) do
    %{
      data: render_grouped(messages, []),
      pagination: pagination
    }
  end

  def render("message.json", %{message: message}) do
    date_key = message.inserted_at
      |> Timex.to_date
      |> formatDate

    %{
      id: message.id,
      inserted_at: message.inserted_at,
      text: message.text,
      key: date_key,
      user: %{
        email: message.user.email,
        username: message.user.username
      }
    }
  end

  def render_grouped([h | messages], result) do
    [date, values] = h
    fdate = formatDate(date)
    json = render_many(values, MessageView, "message.json")

    render_grouped(messages, [%{ date: fdate, values: json } | result])
  end

  def render_grouped([], result), do: Enum.reverse(result)

  defp formatDate(date) do
    today = Timex.today
    yesterday = Timex.shift(today, days: -1)

    case date do
      ^today -> "Today"
      ^yesterday -> "Yesterday"
      _ -> Timex.format!(date, "%B %-d", :strftime)
    end
  end
end
