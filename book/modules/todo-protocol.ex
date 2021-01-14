Code.compile_file("#{__DIR__}/todo-import.ex")

defimpl String.Chars, for: TodoList do
    def to_string(_) do
        "#TodoList"
    end
end

defimpl Collectable, for: TodoList do
    def into(original) do
        { original, &into_callback/2 }
    end

    defp into_callback(todo_list, { :cont, entry }) do
        TodoList.add_entry(todo_list, entry)
    end

    defp into_callback(todo_list, :done), do: todo_list

    defp into_callback(_todo_list, :halt), do: :ok
end

# --------------------------------------------------
# Example:
# --------------------------------------------------
# todo_list = for entry <- entries, into: TodoList.new(), do: entry
# IO.inspect(todo_list, label: "comprehension")
