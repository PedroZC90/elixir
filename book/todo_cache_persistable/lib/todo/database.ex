defmodule Todo.Database do
    use GenServer

    @db_folder "./persist"

    def start() do
        # __MODULE__ store the module name
        # setting GenServer property :name makes the server a singleton
        GenServer.start(__MODULE__, nil, name: __MODULE__)
    end

    def store(key, data) do
        GenServer.cast(__MODULE__, { :store, key, data })
    end

    def get(key) do
        GenServer.call(__MODULE__, { :get, key })
    end

    def clear() do
        File.rm_rf!(@db_folder)
    end

    @impl GenServer
    def init(_) do
        File.mkdir_p!(@db_folder)
        { :ok, nil }
    end

    @impl GenServer
    def handle_cast({ :store, key, data }, state) do
        spawn(fn () ->
            key
                |> file_name()
                |> File.write!(:erlang.term_to_binary(data))
        end)
        { :noreply, state }
    end

    @impl GenServer
    def handle_call({ :get, key }, caller_pid, state) do
        spawn(fn () ->
            data = case File.read(file_name(key)) do
                { :ok, contents } -> :erlang.binary_to_term(contents)
                _ -> nil
            end
            GenServer.reply(caller, data)
        end)
        { :noreply, state }
    end

    defp file_name(key) do
        Path.join(@db_folder, to_string(key))
    end
end
