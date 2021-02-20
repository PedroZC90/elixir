# reference: https://elixir-lang.org/getting-started/try-catch-and-rescue.html

Code.require_file("CustomError.ex", "#{__DIR__}")

import ExUnit.Assertions

add = fn (x, y) -> x + y end

assert_raise(ArithmeticError, fn () -> add.(1, :foo) end)
assert_raise(RuntimeError, fn () -> raise("oops") end)
assert_raise(ArgumentError, fn () -> raise(ArgumentError, message: "invalid argument foo") end)

assert_raise(CustomError, fn () -> raise(CustomError) end)
assert_raise(CustomError, fn () -> raise(CustomError, message: "custom message") end)

# errors can be rescued using the try/rescue construct
try do
    raise("oops")
rescue
    e in RuntimeError -> e
end

case File.read("#{__DIR__}/unknown.txt") do
    { :ok, content } -> IO.puts("File Conten: #{content}")
    { :error, reason } -> IO.puts("Error: #{reason}")
end

## THROWS
try_throw = fn () ->
    try do
        Enum.each(-50..50, fn(x) ->
            if rem(x, 13) == 0, do: throw(x)
        end)
        "Got nothing"
    catch
        x -> "Got #{x}"
    end
end

assert(try_throw.() === "Got -39")

## ELSE
try_else = fn (x, y) ->
    try do
        x / y
    rescue
        ArithmeticError -> :infinity
    else
        # v = x / y
        v when v < 1 and v > -1 -> :small
        _ -> :large
    end
end

assert(:infinity = try_else.(1, 0))
assert(:small = try_else.(1, 2))

## VARIABLE ESCOPE
## variables defined inside try/catch/rescue/after blocks do not leak to the outer context
try_scope = fn () ->
    try do
        raise("oops")
        :did_not_raise
    rescue
        _ -> :rescued
    end
end

what_happened = try_scope.()
assert(:rescued = what_happened)
