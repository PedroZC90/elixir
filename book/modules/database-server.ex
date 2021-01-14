defmodule DatabaseServer do

    def start() do
        spawn(&loop/0)
    end

    def run_async(server_pid, query_def) do
        send(server_pid, { :run_query, self(), query_def })
    end

    def get_result() do
        receive do
            { :query_result, result } -> result
        after
            5000 -> { :error, :timeout }
        end

    end

    defp loop() do
        receive do
            { :run_query, caller, query_def } ->
                send(caller, { :query_result, run_query(query_def) })
        end
        loop()
    end

    defp run_query(query_def) do
        Process.sleep(2000)
        "#{query_def} result"
    end
end

server_pid = DatabaseServer.start()
IO.inspect(server_pid, label: "server pid")

{ :run_query, _pid, _ } = DatabaseServer.run_async(server_pid, "query #1")

response = DatabaseServer.get_result()
IO.puts(response)

{ :run_query, _pid, _} =  DatabaseServer.run_async(server_pid, "query #2")

response =  DatabaseServer.get_result()
IO.puts(response)

pool = Enum.map(1..100, fn (_) -> DatabaseServer.start() end)

Enum.each(1..5, fn (query_def) ->
    position = pool
        |> length()
        |> :rand.uniform()
        |> IO.inspect(label: "position #{query_def}")

    server_pid = Enum.at(pool, position - 1)
        |> IO.inspect(label: "position #{query_def}")

    DatabaseServer.run_async(server_pid, query_def)
end)

results = Enum.map(1..5, fn (_) -> DatabaseServer.get_result() end)
IO.inspect(results)

state = Enum.map(pool, fn (pid) -> Process.alive?(pid) end)
IO.inspect(state, label: "state")
