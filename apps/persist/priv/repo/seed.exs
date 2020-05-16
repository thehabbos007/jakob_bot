alias Persist.Repo

defmodule Parallel do
  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end

data_dumps = Path.wildcard("apps/persist/data/*")

messages = data_dumps
|> Parallel.pmap(fn x -> File.read(x) end)
|> Parallel.pmap(fn {:ok, content} -> Floki.parse_document(content) end)
|> Parallel.pmap(fn {:ok, doc} -> Floki.find(doc, ".text") |> Parallel.pmap(fn x -> Floki.text(x) end) end)
|> List.flatten


#{:ok, file} = File.read("apps/persist/data/test.html")
#{:ok, doc} = Floki.parse_document(file)
#input = Floki.find(doc, ".text") |> Enum.map(fn x -> Floki.text(x) end)

IO.inspect messages |> Enum.count
#input |> Enum.each(fn x -> Persist.MarkovMessage.insert(x) end)
