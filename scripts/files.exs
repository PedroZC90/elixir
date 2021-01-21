# READ A FILE
readfile = fn (f) ->
    case File.read(f) do
        { :ok, body } -> IO.inspect(body, label: "body")    # do something with the `body`
        { :error, reason } -> reason                        # handle the error caused by `reason`
    end
end

readfile.("../README.md")
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.each(fn ({ v, index }) -> IO.inspect("line [#{index}]: #{v}") end)

# CURRENT DIRECTORY
dirname = File.cwd()
    |> IO.inspect(label: "cwd")
    |> case do
        { :ok, cwd } -> Path.join(cwd, "docs")
        _msg -> nil
    end
    |> IO.inspect(label: "dirname")

dirname = File.cwd!()
    |> IO.inspect(label: "cwd")
    |> Path.join("docs")
    |> IO.inspect(label: "dirname")

# SAVE TERMS (LIST, TUPLE, MAP, STRUCTS, etc..) ON A FILE
term = %{ name: "pedro", age: 30, birth: ~D[1990-06-02], values: [ 1, 2, 3 ] }

filename = "#{__DIR__}/debug.txt"

binary = term
    |> :erlang.term_to_binary()
    |> IO.inspect(label: "binary term")

:ok = File.write!(filename, binary)

content = filename
            |> File.read!()
            |> :erlang.binary_to_term()
            |> IO.inspect(label: "file content")
