defmodule Api.Services.Md5 do
  def process(string) do
    :crypto.hash(:md5, string) |> Base.encode16(case: :lower)
  end
end
