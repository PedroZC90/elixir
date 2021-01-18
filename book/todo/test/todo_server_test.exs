defmodule TodoServerTest do
    use ExUnit.Case, async: true

    setup (_) do
        { :ok, todo_server } = Todo.Server.start()
        on_exit(fn () -> GenServer.stop(todo_server) end)
        { :ok, todo_server: todo_server }
    end

    test("add_entry", { todo_server: todo_server }) do
        entries = Todo.Server.entries(todo_server, ~D[2021-01-17])
        assert([] == entries)

        Todo.Server.add_entry(todo_server, %{ date: ~D[2021-01-17], title: "Dentista" })

        entries = Todo.Server.entries(todo_server, ~D[2021-01-17])
        assert(is_list(entries))
        assert(%{ date: _, id: 1, title: "Dentista" } = Enum.at(entries, 0))
    end
end
