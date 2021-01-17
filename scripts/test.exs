list = [ "pedro", "tuca", "pedro" ]

stream = list
    |> Enum.reduce(%{}, fn (element, acc) ->
        IO.inspect(acc, label: "accumulator")
        Map.update(acc, element, 1, fn (current_value) -> current_value + 1 end)
    end)
    |> IO.inspect(label: "result")
