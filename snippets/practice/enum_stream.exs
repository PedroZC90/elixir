defmodule Practice.EnumStream do
    def filter_lines!(path) do
        path
            |> File.stream!()
            |> Stream.filter(fn (v) -> String.replace(v, "\n", "") end)
    end

    def large_lines!(path) do
        path
            |> filter_lines!()
            |> Enum.filter(fn (v) -> String.length(v) > 80 end)
    end

    @doc """
    takes a file path and returns a list of numbers, with each number
    representing the lenght of the corresponding line from the file.
    """
    def lines_length!(path) do
        path
            |> filter_lines!()
            |> Stream.map(fn (v) -> String.length(v) end)
            |> Enum.to_list()
    end

    @doc """
    returns the length of the longest line in a file.
    """
    def longest_line_length!(path) do
        path
            |> filter_lines!()
            |> Enum.map(fn (v) -> String.length(v) end)
            |> Enum.max()
    end

    @doc """
    returns the contents of the longest line in a file.
    """
    def longest_line!(path) do
        path
            |> filter_lines!()
            |> Enum.max_by(&String.length/1)
    end

    @doc """
    return a list of numbers, with each number representing the word count in a line.
    """
    def words_per_line!(path) do
        path
            |> filter_lines!()
            |> Enum.map(&word_count/1)
    end

    @doc """
    Count the number of words in a line.
    """
    defp word_count(s) do
        s
            |> String.split()
            |> Kernel.length()
    end
end
