defmodule PageCache do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :page_cache)
  end

  def cached(key, fun) do
    GenServer.call(:page_cache, {:cached, key, fun})
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:cached, key, fun}, _, cache) do
    case Map.get(cache, key) do
      nil ->
        response = fun.()
        {:reply, response, Map.put(cache, key, response)}

      response ->
        {:reply, response, cache}
    end
  end
end
