defmodule TodoCacheTest do
    use ExUnit.Case, async: true

    setup (_) do
        { :ok, cache } = Todo.Cache.start()
        %{ cache: cache }
    end

    test("server process", %{ cache: cache }) do
        bob_list = Todo.Cache.server_process(cache, "Bob's List")
        assert(bob_list |> is_pid())

        alice_list = Todo.Cache.server_process(cache, "Alice's List")
        assert(alice_list |> is_pid())

        assert(bob_list != alice_list)

        assert(bob_list === Todo.Cache.server_process(cache, "Bob's List"))

        count = Todo.Cache.servers(cache)
        assert(count |> is_number())
        assert(count === 2)

        Todo.Server.add_entry(bob_list, %{ date: ~D[2021-01-17], title: "Dentista" })
        bob_entries = Todo.Server.entries(bob_list, ~D[2021-01-17])
        assert([%{ date: ~D[2021-01-17], id: 1, title: "Dentista" }] = bob_entries)

        alice_entries = Todo.Server.entries(alice_list, ~D[2021-01-17])
        assert([] = alice_entries)
    end

    test("multiple servers process", %{ cache: cache }) do
        servers = Enum.map(1..100_000, fn (index) -> Todo.Cache.server_process(cache, "to-do-list-#{index}") end)
        assert(servers |> is_list())
        assert(servers |> Enum.at(0) |> is_pid())

        process_count = :erlang.system_info(:process_count)
        IO.inspect(process_count, label: "process_count")
        assert(is_number(process_count) and process_count >= 100_000)
    end
end
