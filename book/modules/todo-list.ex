Code.compile_file("#{__DIR__}/todo-multi-dict.ex")

defmodule TodoListSimple do
    def new(), do: %{}

    def add_entry(todo_list, date, title) do
        Map.update(todo_list, date, [title], fn (titles) -> [title | titles] end)
    end

    def entries(todo_list, date) do
        Map.get(todo_list, date, [])
    end
end

defmodule TodoListMultiDict do
    def new(), do: MultiDict.new()

    def add_entry(todo_list, date, title) do
        MultiDict.add(todo_list, date, title)
    end

    def entries(todo_list, date) do
        MultiDict.get(todo_list, date)
    end
end

defmodule TodoList do
    def new(), do: MultiDict.new()

    def add_entry(todo_list, entry) do
        MultiDict.add(todo_list, entry.date, entry)
    end

    def entries(todo_list, date) do
        MultiDict.get(todo_list, date)
    end
end
