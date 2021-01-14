defmodule Loop do
    defmodule Recursion do
        @doc """
        Calculates the length of a list.
        """
        def list_len([]), do: 0
        def list_len([_head | tail]), do: 1 + list_len(tail)

        @doc """
        Takes two integers ('from' and 'to') and returns
        a list of all numbers in the given range.
        """
        def range(to, to) do
            [to]
        end

        def range(from, to) when from < to do
            [from | range(from + 1, to)]
        end

        def range(from, to) when from > to do
            [from | range(from - 1, to)]
        end

        @doc """
        Takes a list and returns another list that contains
        only the positive numbers from the input list.
        """
        def positive([]), do: []

        def positive([head | tail]) when head > 0 do
            [head | positive(tail)]
        end

        def positive([_ | tail]) do
            positive(tail)
        end
    end

    defmodule TailRecursion do
        @doc """
        Calculates the length of a list.
        """
        def list_len(list), do: list_len(list, 0)

        defp list_len([], len), do: len

        defp list_len([_head | tail], len), do: list_len(tail, len + 1)

        @doc """
        Takes two integers ('from' and 'to') and returns
        a list of all numbers in the given range.
        """
        def range(from, to), do: range(from, to, [])

        defp range(to, to, result) do
            [ to | result]
        end

        defp range(from, to, result) when from > to do
            range(from - 1, to, [from | result])
        end

        defp range(from, to, result) when from < to do
            range(from + 1, to, [from | result])
        end

        @doc """
        Takes a list and returns another list that contains
        only the positive numbers from the input list.
        """
        def positive(list) do
            positive(list, [])
        end

        defp positive([], result), do: result

        defp positive([head | tail], result) when head > 0 do
            positive(tail, [head | result])
        end

        defp positive([_ | tail], result) do
            positive(tail, result)
        end
    end
end

# --------------------------------------------------
# Example:
# --------------------------------------------------
# IO.puts("Recursion")
# length = Loop.Recursion.list_len([1, 2, 3, 4, 5, 6, 7, 8])
# IO.inspect(length, label: "length")

# range = Loop.Recursion.range(0, 10)
# IO.inspect(range, label: "range")

# range = Loop.Recursion.range(10, 0)
# IO.inspect(range, label: "range")

# positives = Loop.Recursion.positive([1, -1, 3, -5, 0, -1, 10])
# IO.inspect(positives, label: "positives")

# IO.puts("\nTail Recursion")

# length = Loop.TailRecursion.list_len([1, 2, 3, 4, 5, 6, 7, 8])
# IO.inspect(length, label: "length")

# range = Loop.TailRecursion.range(0, 10)
# IO.inspect(range, label: "range")

# range = Loop.TailRecursion.range(10, 0)
# IO.inspect(range, label: "range")

# positives = Loop.TailRecursion.positive([1, -1, 3, -5, 0, -1, 10])
# IO.inspect(positives, label: "positives")
