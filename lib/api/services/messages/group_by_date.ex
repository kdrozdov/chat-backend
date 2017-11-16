defmodule Api.Services.Messages.GroupByDate do
  def process(messages) do
    messages
      |> Enum.group_by(&messageDate/1)
      |> Enum.map(fn {k, v} -> [k, Enum.reverse(v)] end)
      |> Enum.sort(&sort/2)
  end

  defp sort(m1, m2) do
    Timex.Comparable.compare(hd(m1), hd(m2)) >= 0
  end

  defp messageDate(message) do
    message.inserted_at
      |> Timex.to_date
  end
end
