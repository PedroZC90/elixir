defmodule TodoCacheTest do
    use ExUnit.Case, async: true

    setup (_) do
        { :ok, cache } = Todo.Cache.start()
        %{ cache: cache }
    end

    test("server process", %{ cache: cache }) do
        bob_pid = Todo.Cache.server_process(cache, "bob")
        assert(bob_pid |> is_pid())

        alice_pid = Todo.Cache.server_process(cache, "alice")
        assert(alice_pid |> is_pid())

        assert(bob_pid != alice_pid)

        assert(bob_pid === Todo.Cache.server_process(cache, "bob"))
    end

    test("persistence", %{ cache: cache }) do
        john = Todo.Cache.server_process(cache, "john")
        Todo.Server.add_entry(john, %{ date: ~D[2018-12-20], title: "Shopping" })
        assert(1 === length(Todo.Server.entries(john, ~D[2018-12-20])))

        GenServer.stop(cache)
        { :ok, cache } = Todo.Cache.start()

        entries = cache
            |> Todo.Cache.server_process("john")
            |> Todo.Server.entries(~D[2018-12-20])

        assert([%{ date: ~D[2018-12-20], title: "Shopping" }] = entries)
    end
end
