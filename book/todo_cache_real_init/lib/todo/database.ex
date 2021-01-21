defmodule Todo.Database do
    use GenServer

    @db_folder "./persist"

    def start() do
        # __MODULE__ store the module name
        # setting GenServer property :name makes the server a singleton
        GenServer.start(__MODULE__, nil)
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
        send(self(), :real_init)
        Process.register(self(), __MODULE__)
        { :ok, nil }
    end

    @impl GenServer
    def handle_info(:real_init, state) do
        File.mkdir_p!(@db_folder)
        { :noreply, state }
    end

    @impl GenServer
    def handle_cast({ :store, key, data }, state) do
        key
            |> file_name()
            |> File.write!(:erlang.term_to_binary(data))

        { :noreply, state }
    end

    @impl GenServer
    def handle_call({ :get, key }, _, state) do
        data = case File.read(file_name(key)) do
            { :ok, contents } -> :erlang.binary_to_term(contents)
            _ -> nil
        end
        { :reply, data, state }
    end

    defp file_name(key) do
        Path.join(@db_folder, to_string(key))
    end
end
