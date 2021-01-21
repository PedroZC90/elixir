defmodule TodoWorkerTest do
    use ExUnit.Case, async: true

    test("create file") do
        worker_pid = File.cwd!()
            |> Path.join("_storage")
            |> Todo.Database.Worker.start()
            |> IO.inspect(label: "pid")

        Todo.Database.Worker.get(worker_pid, "hello")
            |> IO.inspect(label: "get")
    end
end
