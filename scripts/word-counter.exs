# WORD COUNTER
# read all files from a give folder and count the frequency of each word.

number_of_processes = 10
self_pid = self()
    |> IO.inspect(label: "self")

File.cwd!() |> IO.inspect(label: "cwd")

dirname =__DIR__
    |> Path.join("../docs/files")
    |> IO.inspect(label: "dirname")

files = dirname
    # list directory
    |> File.ls!()
    # concat absolute path (directory + filename)
    |> Stream.map(fn (filename) -> Path.join(dirname, filename) end)
    # take a few files, not all of them
    |> Stream.take(number_of_processes)
    # spawn a process for each file
    |> Enum.map(fn (path) ->
        # spawn a new procces for each file (returns process id)
        spawn(fn () ->
            words = path
                |> File.stream!()
                # read line per line
                # collect words from line
                |> Stream.map(fn (line) ->
                    line
                        |> String.downcase()
                        |> String.replace(["”", "“", ".", ",", ":", ";", "!", "?"], " ")
                        |> String.replace("’", "\'")
                        |> String.replace("'s", " ")
                        |> String.split(~r/[\s]/, trim: true)
                end)
                # filter empty lines
                |> Stream.filter(fn (v) -> length(v) > 0 end)
                # concatenate lists
                |> Stream.concat()
                # remove useless words
                |> Stream.filter(fn
                    ("a") -> false
                    ("and") -> false
                    ("at") -> false
                    ("for") -> false
                    ("in") -> false
                    ("of") -> false
                    ("on") -> false
                    ("the") -> false
                    ("to") -> false
                    (nil) -> false
                    (v) -> String.length(v) > 0
                end)
                # compute words frequency
                |> Enum.frequencies()

            # send message back to main process
            Kernel.send(self_pid, { :result, { path, words } })
        end)
    end)
    |> IO.inspect(label: "pids")

range = 1..length(files)

# join all process results
frequency = Enum.reduce(range, %{}, fn (_, acc) ->
        # wait for messagem from spawned process
        receive do
            { :result, { path, words } } ->
                Enum.reduce(words, acc, fn ({ key, value }, new_acc) ->
                    # if accumultor do not contains the 'key', use 'value' as default.
                    # if accumultor contains the 'key', sum 'value' to the 'current_value'.
                    Map.update(new_acc, key, value, fn (current_value) -> current_value + value end)
                end)
            _ ->
                IO.puts("nothing...")
                acc
        end
    end)
    # sort most frequenct word first
    |> Enum.sort(fn ({ _, value_1 }, { _, value_2 }) -> value_1 >= value_2 end)

IO.inspect(Enum.take(frequency, 20), label: "frequency")

File.open("#{__DIR__}/result.txt", [ :write ], fn (file) ->
    frequency
        |> Enum.each(fn ({ key, value }) ->
            IO.write(file, "#{key}: #{value}\n")
        end)
    # File.close(file)
end)
