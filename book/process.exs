import ExUnit.Assertions

# PROCESSES
run_query = fn (query_def) ->
    Process.sleep(2000)
    "result of #{query_def}"
end

res = run_query.("query #1") |> IO.inspect()
assert(is_bitstring(res))

# res = Enum.map(1..5, fn (v) -> run_query.("##{v}") end)
#     |> IO.inspect()
# assert(is_list(res))

## CREATING PROCESSES
pid = spawn(fn () -> IO.puts(run_query.("async query #1")) end)
    |> IO.inspect(label: "PID")
assert(is_pid(pid))

async_query = fn (query_def) ->
    spawn(fn () ->
        IO.puts(run_query.(query_def))
    end)
end

pid = async_query.("async query #1")
    |> IO.inspect(label: "Async PID")
assert(is_pid(pid))

Enum.each(1..5, fn (v) -> async_query.("async query ##{v}") end)

## MESSAGES
IO.inspect(self(), label: "self")

# send a message to itself
send(self(), "A Message")

# read message from mailbox
receive do
    message -> IO.inspect(message, label: "received message")
end

# use pattern-match to read a specific message
send(self(), { :message, 1 })
receive do
    { :message, id } -> IO.puts("received message #{id}")
end

# if there is no message in the mailbox, 'receive' waits
# indefinetly for a new message to arraive
receive do
    message -> IO.inspect(message, label: "received message")
    after (5000) -> IO.puts("no message received.")
end

# NOTES: if a message can't be matched agains provided pattern:
# 1. 'receive' awaits for a new message
# 2. 'receive' expression do not raise an error, and the message
# is put back into the process mailbox (in the same position)
receive do
    { _, _, _ } -> IO.puts("received")
    after (5000) -> IO.puts("no message received.")
end

send(self(), { :message, 1 })
receive_result = receive do
    { :message, v } -> v + 2
end
assert(receive_result
    |> IO.inspect(label: "receive result")
    |> (fn (v) -> is_number(v) and v === 3 end).())

async_query = fn (query_def) ->
    # store the pid of the calling process
    caller = self()
    spawn(fn () ->
        send(caller, { :query_result, run_query.(query_def) })
    end)
end

Enum.each(1..5, fn (v) -> async_query.("query #{v}") end)

get_result = fn () ->
    receive do
        { :query_result, result } -> result
        after (5000) -> IO.puts("no message received.")
    end
end

results = 1..5
    |> Enum.map(fn (_) -> get_result.() end)
    |> IO.inspect(label: "results")

## MUTABLE STATE
##
## is a typical stateful server
##
## def loop(state) do
##      new_state = receive do
##          msg_1 -> ...
##          msg_2 -> ...
##          msg_3 -> ...
##      end
##      loop(new_state)
## end
