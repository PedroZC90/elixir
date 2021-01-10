import ExUnit.Assertions

# COMPREHENSIONS

result = for v <- [1, 2, 3] do
    v * v
end
# IO.inspect(result, label: "result")
assert(is_list(result))
assert([1, 4, 9] = result)

result = for x <- [1, 2, 3], y <- [1, 2, 3], do: { x, y, x * y }
# IO.inspect(result, label: "result")
assert(is_list(result))

result = for x <- 1..9, y <- 1..9, do: { x, y, x * y }
# IO.inspect(result, label: "result")
assert(is_list(result) && Kernel.length(result) === 81)

result = for x <- 1..3, y <- 9..7, z <- 2..3, do: { x, y, z, x + y + z }
# IO.inspect(result, label: "result")
assert(is_list(result))

## COLLECTION TYPES
multiplication_table = for x <- 1..9, y <- 1..9, into: %{} do
   {{x, y}, x * y}
end
# IO.inspect(multiplication_table, label: "multiplication_table")
assert(multiplication_table[{7, 6}] === multiplication_table[{6, 7}])

## FILTERS
multiplication_table = for x <- 1..9, y <- 1..9, x <= y, into: %{} do
    {{x, y}, x * y}
end
# IO.inspect(multiplication_table, label: "filtered multiplication_table")
assert(multiplication_table[{6, 7}] !== multiplication_table[{7, 6}])
assert(multiplication_table[{7, 6}] === nil)

# filter odd elements from 'y' collection
result = for x <- [1, 2, 3], y <- [2, 3, 4], rem(y, 2) === 0, do: { x, y, x + y }
# IO.inspect(result, label: "result")
assert(is_list(result) && Kernel.length(result) === 6)

# filter even elements from 'y' collection
result = for x <- [1, 2, 3], y <- [2, 3, 4], rem(y, 2) !== 0, do: { x, y, x + y }
# IO.inspect(result, label: "result")
assert(is_list(result) && Kernel.length(result) === 3)

# PIPE OPERATOR
employees = [ "Alice", "Bob", "John" ]

employees_with_index = Enum.with_index(employees)

employees
    |> Enum.with_index
    |> Enum.each(fn ({ v, index }) ->
        IO.puts("#{index + 1}. #{v}")
    end)

# STREAM
stream = [1, 2, 3]
    |> Stream.map(fn (v) -> 2 * v end)
assert(is_struct(stream, Stream))

result = Enum.to_list(stream)
assert(is_list(result))

# takes 1 element from stream response
result = Enum.take(stream, 1)
assert(is_list(result) && result === [2])

# takes 2 element from stream response
result = Enum.take(stream, 2)
assert(is_list(result) && result === [2, 4])

result = employees
    |> Stream.with_index
    |> Enum.each(fn ({ v, index }) ->
        IO.puts("#{index + 1}. #{v}")
    end)
assert(result === :ok)

result = [9, -1, "foo", 25, 49, :atom]
    |> Stream.filter(&(is_number(&1) and &1 > 0))
    |> Stream.map(&{&1, :math.sqrt(&1)})
    |> Stream.with_index
    |> Enum.each(fn ({ { input, value }, index }) ->
        IO.puts("#{index + 1}. sqrt(#{input}) = #{value}")
    end)
assert(result === :ok)

# stream lazy property is useful for consuming slow and potentially large enumerables.
# a typical case is when you need to parse each line of a file.
# using Enum function the entire will be loaded into memory.
defmodule FileHelper do
    def large_lines!(filename) do
        File.stream!(filename)
            |> Stream.map(fn (v) -> String.replace(v, "\n", "") end)
            |> Enum.filter(fn (v) -> String.length(v) > 80 end)
    end
end

filename = Path.join(File.cwd!(), "/pattern-matching.exs")

FileHelper.large_lines!(filename)
    |> Stream.with_index
    |> Enum.each(fn ({v, index}) ->
        IO.puts("#{index + 1}. #{v}")
    end)
