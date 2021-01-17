Code.compile_file("#{__DIR__}/todo-builder.ex")

defmodule TodoServer do
    use GenServer

    def start() do
        GenServer.start(__MODULE__, nil, name: __MODULE__)
    end

    def add_entry(todo_server, new_entry) do
        GenServer.cast(todo_server, { :add_entry, new_entry })
    end

    def add_entry(new_entry) do
        add_entry(__MODULE__, new_entry)
    end

    def entries(todo_server, date) do
        GenServer.call(todo_server, { :entries, date })
    end

    def entries(date) do
        entries(__MODULE__, date)
    end

    # def delete_entry(todo_server, id) do
    #     GenServer.cast(todo_server, { :delete_entry, id })
    # end

    # def delete_entry(id) do
    #     delete_entry(__MODULE__, id)
    # end

    # def update_entry(todo_server, id) do
    #     GenServer.cast(todo_server, { :update_entry, id })
    # end

    # def update_entry(id) do
    #     update_entry(__MODULE__, id)
    # end

    @impl GenServer
    def init(_) do
        { :ok, TodoList.new() }
    end

    @impl GenServer
    def handle_cast({ :add_entry, new_entry }, todo_list) do
        new_state = TodoList.add_entry(todo_list, new_entry)
        { :noreply, new_state }
    end

    @impl GenServer
    def handle_call({ :entries, date }, _, todo_list) do
        entries = TodoList.entries(todo_list, date)
        { :reply, entries, todo_list }
    end

    # @impl GenServer
    # def handle_cast({ :update_entry, %{} = new_entry }, todo_list) do
    #     { :noreply, TodoList.update_entry(todo_list, new_entry) }
    # end

    # @impl GenServer
    # def handle_cast({ :update_entry, entry_id, updater_fun }, todo_list) do
    #     { :noreply, TodoList.update_entry(todo_list, entry_id, updater_fun) }
    # end

    # @impl GenServer
    # def handle_cast({ :delete_entry, entry_id }, todo_list) do
    #     { :noreply, TodoList.delete_entry(todo_list, entry_id) }
    # end
end

{ :ok, pid } = TodoServer.start()
IO.inspect(pid, label: "To Do Server")

TodoServer.add_entry(%{ date: ~D[2020-01-17], title: "Title A" })
TodoServer.add_entry(%{ date: ~D[2020-01-18], title: "Title B" })
TodoServer.add_entry(%{ date: ~D[2020-01-18], title: "Title C" })

entries = TodoServer.entries(~D[2020-01-18])
IO.inspect(entries, label: "entries")
