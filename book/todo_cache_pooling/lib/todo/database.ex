defmodule Todo.Database do
    use GenServer

    @db_folder "./persist"

    def start() do
        GenServer.start(__MODULE__, nil, name: __MODULE__)
    end

    def store(key, data) do
        key
            |> choose_worker()
            |> Todo.Database.Worker.store(key, data)
    end

    def get(key) do
        key
            |> choose_worker()
            |> Todo.Database.Worker.get(key)
    end

    def clear() do
        File.rm_rf!(@db_folder)
    end

    @impl GenServer
    def init(_) do
        File.mkdir_p!(@db_folder)
        { :ok, start_worker() }
    end

    @impl GenServer
    def handle_call({ :choose_worker, key }, _, workers) do
        # computes key numerical hash and normalize it to fall into range [0,2]
        worker_key = :erlang.phash2(key, 3)
        { :reply, Map.get(workers, worker_key), workers }
    end

    defp choose_worker(key) do
        GenServer.call(__MODULE__, { :choose_worker, key })
    end

    defp start_worker() do
        for index <- 1..3, into: %{} do
            { :ok, pid } = Todo.Database.Worker.start(@db_folder)
            { index - 1, pid }
        end
    end
end
