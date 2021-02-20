Code.require_file("fraction.ex", "#{__DIR__}/modules")

import ExUnit.Assertions

# ERROR HANDLING

## Error Types
assert_raise(ArithmeticError, fn () -> (fn (a, b) -> a / b end).(1, 0) end)
assert_raise(UndefinedFunctionError, fn () -> Fraction.division(1, 2) end)
assert_raise(FunctionClauseError, fn () -> List.first({ 1, 2, 3 }) end)

## Error Raise
assert_raise(RuntimeError, fn () -> raise("Sommething went wrong.") end)

# elixir convention: function end with ! raiie an error with it fail.
assert_raise(File.Error, fn () -> File.read!("nonexistent_file.md") end)
assert({ :error, :enoent } = File.read("nonexistent_file.md"))

## Exit
spawn(fn () ->
    exit("Process Done")
    IO.puts("This line won't be reached.")
end)

## Throw
## throw(:thrown_value)

## Try / Catch
try do
    throw(:thrown_value)
catch error_type, error_value ->
    assert(error_type === :throw)
    assert(error_value === :thrown_value)
end

try do
    exit("Done")
catch error_type, error_value ->
    assert(error_type === :exit)
    assert(error_value === "Done")
end

try do
    raise("Sommething went wrong.")
catch error_type, error_value ->
    assert(error_type === :error)
    assert(is_struct(error_value, RuntimeError))
end

## HANDLING ERRORS

try_helper = fn (fun) ->
    try do
        fun.()
        IO.puts("No error.")
    catch
        :throw, { :result, value } -> value
        :throw, value -> { :throw, value }
        type, value ->
            # IO.puts("Error\ntype: #{inspect(type)}\nvalue: #{inspect(value)}")
            { type, value }
    end
end

{ :error, msg } = try_helper.(fn () -> raise("Sommething went wrong") end)
{ :throw, msg } = try_helper.(fn () -> throw("Thrown value") end)
{ :exit, msg } = try_helper.(fn () -> exit("I'm done") end)

reason = try_helper.(fn () -> throw({ :result, "Rock Throw" }) end)
assert(reason === "Rock Throw")

try do
    raise("Sommething went wrong.")
catch
    _, _ -> IO.puts("Error caught")
after
    IO.puts("Cleanup code")
end

## PROCESS
spawn(fn () ->
    IO.puts("Process 1 started")
    spawn(fn () ->
        IO.puts("Process 2 started")
        Process.sleep(2000)
        IO.puts("Process 2 finished")
    end)

    raise("oops")
    IO.puts("Process 1 finished")
end)
