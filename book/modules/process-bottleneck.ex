# PROCESS BOTTLENECK
defmodule Server do
    def start() do
        spawn(fn () -> loop() end)
    end

    def send_msg(server, message) do
        send(server, { self(), message })
        receive do
            { :response, response } -> response
        end
    end

    defp loop() do
        receive do
            { pid, msg } ->
                Process.sleep(1000)
                send(pid, { :response, msg })
        end
        loop()
    end
end

server_pid = Server.start()

Enum.each(1..5, fn (v) ->
    spawn(fn () ->
        IO.puts("Sending msg ##{v}")
        response = Server.send_msg(server_pid, v)
        IO.puts("Response: #{response}")
    end)
end)
