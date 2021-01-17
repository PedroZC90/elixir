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
