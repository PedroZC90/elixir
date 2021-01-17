defmodule KeyValueStore do
    use GenServer
end

KeyValueStore.__info__(:functions)
    |> IO.inspect(label: "functions")

# list of functions imported from GenServer
# [
#     child_spec: 1,
#     code_change: 3,
#     handle_call: 3,
#     handle_cast: 2,
#     handle_info: 2,
#     init: 1,
#     terminate: 2
# ]

{ :ok, pid } = GenServer.start(KeyValueStore, nil)
