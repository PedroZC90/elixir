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

defmodule KeyValueStore do
    # Client Interface
    def start() do
        ServerProcess.start(KeyValueStore)
    end

    def put(pid, key, value) do
        ServerProcess.cast(pid, { :put, key, value })
    end

    def get(pid, key) do
        ServerProcess.call(pid, { :get, key })
    end

    # Server API
    def init() do
        %{}
    end

    def handle_cast({ :put, key, value }, state) do
        Map.put(state, key, value)
    end

    def handle_call({ :get, key }, state) do
        { Map.get(state, key), state }
    end
end

# pid = KeyValueStore.start()
# KeyValueStore.put(pid, :some_key, "some_value")
# KeyValueStore.get(pid, :some_key)
