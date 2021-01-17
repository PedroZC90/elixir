defmodule KeyValueStore do
    use GenServer

    # Client Interface
    def start() do
        GenServer.start(__MODULE__, nil, name: __MODULE__)
    end

    def put(pid, key, value) do
        GenServer.cast(pid, { :put, key, value })
    end

    def put(key, value) do
        GenServer.cast(__MODULE__, { :put, key, value })
    end

    def get(pid, key) do
        GenServer.call(pid, { :get, key })
    end

    def get(key) do
        GenServer.call(__MODULE__, { :get, key })
    end

    # Server API
    @impl GenServer
    def init(_) do
        :timer.send_interval(5000, :cleanup)
        { :ok, %{} }
    end

    @impl GenServer
    def handle_info(:cleanup, state) do
        IO.puts("performiong process cleanup...")
        { :noreply, state }
    end

    @impl GenServer
    def handle_cast({ :put, key, value }, state) do
        { :noreply, Map.put(state, key, value) }
    end

    @impl GenServer
    def handle_call({ :get, key }, _request_id, state) do
        { :reply, Map.get(state, key), state }
    end
end

{ :ok, pid } = KeyValueStore.start()
KeyValueStore.put(pid, :some_key, "some_value")
KeyValueStore.get(pid, :some_key)
