defmodule Api.Services.Messages.GroupByDate do
  def process(messages) do
    messages
      |> Enum.group_by(&messageDate/1)
      |> Enum.map(fn {k, v} -> [k, Enum.reverse(v)] end)
      |> Enum.sort(fn (g1, g2) -> hd(g1) >= hd(g2) end)
  end

  defp messageDate(message) do
    message.inserted_at
      |> Timex.to_date
  end
end
