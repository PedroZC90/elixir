import ExUnit.Assertions

# LOOPS
# constructs such as while and do...while do exists in Elixir
# principal lopping tool in Elixir is 'recursion'

## ITERACTIONS WITH RECURSION

defmodule NaturalNumbers do
    # printing the first n natural numbers
    # this method has stack
    def print(n) when n <= 0 do
        print(n + 1)
        IO.puts(n)
    end
    def print(1), do: IO.puts(1)
    def print(n) do
        print(n - 1)
        IO.puts(n)
    end

end

IO.puts("positive:")
NaturalNumbers.print(3)

IO.puts("negative:")
NaturalNumbers.print(-3)

defmodule ListHelper do
    # calculating the sum of the list
    def sum([]), do: 0
    def sum([head | tail]) do
        head + sum(tail)
    end
end

assert(ListHelper.sum([]) === 0)
assert(ListHelper.sum([1, 2, 3]) === 6)

## TAIL FUNCTIONS CALLS
## if the last thing a function does is all another function or itself.
## def original_fun(...) do
##      ...
##      another_fun(...)
## end

# tail-recursive sum of the first n natural numbers
defmodule ListHelperV2 do
    def sum(list) do
        do_sum(0, list)
    end

    defp do_sum(current_sum, []) do
        current_sum
    end

    defp do_sum(current_sum, [head | tail]) do
        do_sum(head + current_sum, tail)
    end
end

assert(ListHelperV2.sum([1, 2, 3]) === 6)
