defmodule Calculator do
    # CLIENT SIDE (INTERFACE FUNCTIONS)
    def start() do
        spawn(fn () -> loop(0) end)
    end

    ## SYNCHRONOUS FUNCTIONS
    def value(server_pid) do
        send(server_pid, { :value, self() })
        receive do
            { :response, value} -> value
        end
    end

    ## ASYNCHRONOUS FUNCTIONS
    def add(server_pid, value), do: send(server_pid, { :add, value })
    def sub(server_pid, value), do: send(server_pid, { :sub, value })
    def div(server_pid, value), do: send(server_pid, { :div, value })
    def mult(server_pid, value), do: send(server_pid, { :mult, value })

    # SERVER SIDE
    # defp loop(current_value) do
        # new_value = receive do
            # { :value, pid } ->
                # send(pid, { :response, current_value })
                # current_value
            # { :add, value } ->
                # current_value + value
            # { :sub, value } ->
                # current_value - value
            # { :mult, value } ->
                # current_value * value
            # { :div, value } ->
                # current_value / value
            # invalid_request ->
                # IO.puts("Invalid request #{IO.inspect(invalid_request)}")
                # current_value
        # end
        # loop(new_value)
    # end
    defp loop(current_value) do
        new_value = receive do
            message -> process_message(current_value, message)
        end
        loop(new_value)
    end

    defp process_message(current_value, { :value, pid }) do
        send(pid, { :response, current_value })
        current_value
    end

    defp process_message(current_value, { :add, value }) do
        current_value + value
    end

    defp process_message(current_value, { :sub, value }) do
        current_value - value
    end

    defp process_message(current_value, { :mult, value }) do
        current_value * value
    end

    defp process_message(current_value, { :div, value }) do
        current_value / value
    end

    defp process_message(current_value, invalid_request) do
        IO.puts("Invalid request #{IO.inspect(invalid_request)}")
        current_value
    end
end
