Code.compile_file("#{__DIR__}/todo-builder.ex")

defmodule ServerProcess do
    @doc """
    Start the server process
    1. invokes the callback module to initialize the state.
    """
    def start(callback_module) do
        spawn(fn () ->
            initial_state = callback_module.init()
            loop(callback_module, initial_state)
        end)
    end


    # Handling messages in the server process.
    defp loop(callback_module, current_state) do
        receive do
            { :call, request, caller_pid } ->
                { response, new_state } = callback_module.handle_call(request, current_state)
                send(caller_pid, { :response, response })
                loop(callback_module, new_state)

            { :cast, request } ->
                new_state = callback_module.handle_cast(request, current_state)
                loop(callback_module, new_state)
        end
    end

    @doc """
    Helper for issuing synchronous requests
    """
    def call(server_pid, request) do
        send(server_pid, { :call, request, self() })

        receive do
            { :response, response } -> response
        end
    end

    @doc """
    Helper for issuing asynchronous requests
    """
    def cast(server_pid, request) do
        send(server_pid, { :cast, request })
    end
end

defmodule TodoServer do

    # Client Interface
    def start() do
        ServerProcess.start(TodoServer)
    end

    def add_entry(todo_server, new_entry) do
        ServerProcess.cast(todo_server, { :add_entry, new_entry })
    end

    def entries(todo_server, date) do
        ServerProcess.call(todo_server, { :entries, date })
    end

    def delete_entry(todo_server, entry_id) do
        ServerProcess.cast(todo_server, { :delete_entry, entry_id })
    end

    def update_entry(todo_server, entry_id) do
        ServerProcess.cast(todo_server, { :update_entry, entry_id })
    end

    # Server API
    def init() do
        TodoList.new()
    end

    def handle_call({ :entries, date }, todo_list) do
        { TodoList.entries(todo_list, date), todo_list }
    end

    def handle_cast({ :add_entry, new_entry }, todo_list) do
        TodoList.add_entry(todo_list, new_entry)
    end

    def handle_cast({ :update_entry, %{} = new_entry }, todo_list) do
        TodoList.update_entry(todo_list, new_entry)
    end

    def handle_cast({ :update_entry, entry_id, updater_fun }, todo_list) do
        TodoList.update_entry(todo_list, entry_id, updater_fun)
    end

    def handle_cast({ :delete_entry, entry_id }, todo_list) do
        TodoList.delete_entry(todo_list, entry_id)
    end
end
