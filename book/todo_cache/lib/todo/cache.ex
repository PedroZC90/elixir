defmodule Todo.Cache do
    use GenServer

    def start() do
        GenServer.start(__MODULE__, nil)
    end

    def server_process(cache_pid, todo_list_name) do
        GenServer.call(cache_pid, { :server_process, todo_list_name })
    end

    def servers(cache_id) do
        GenServer.call(cache_id, { :server_list })
    end

    @impl GenServer
    def init(_) do
        { :ok, %{} }
    end

    @impl GenServer
    def handle_call({ :server_process, todo_list_name }, _, todo_servers) do
        case Map.fetch(todo_servers, todo_list_name) do
            { :ok, todo_server } ->
                { :reply, todo_server, todo_servers }
            :error ->
                { :ok, new_server } = Todo.Server.start()
                { :reply, new_server, Map.put(todo_servers, todo_list_name, new_server) }
        end
    end

    @impl GenServer
    def handle_call({ :server_list }, _, todo_servers) do
        { :reply, Kernel.map_size(todo_servers), todo_servers }
    end
end
