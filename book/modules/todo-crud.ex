defmodule TodoList do
    defstruct auto_id:  1, entries: %{}

    def new(), do: %TodoList{}

    def add_entry(todo_list, entry) do
        # sets a entry's id to the input entry
        entry = Map.put(entry, :id, todo_list.auto_id)

        # adds the input entry into the todo-list entries
        new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)

        # update todo-list struct and increment auto_id
        %TodoList{ todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1 }
    end

    def entries(todo_list, date) do
        todo_list.entries
            # filter entries by date
            |> Stream.filter(fn ({ _, entry }) -> entry.date == date end)
            # takes onle the values
            |> Enum.map(fn ({ _, entry }) -> entry end)
    end

    def update_entry(todo_list, entry_id, update_function) do
        # lookup the entry with the given id
        case Map.fetch(todo_list.entries, entry_id) do
            # no entry with this id
            :error -> todo_list

            { :ok, old_entry } ->
                old_entry_id = old_entry.id
                # change the found entry
                # validate if update_function returns a map
                # and check if entry id changed
                new_entry = %{ id: ^old_entry_id } = update_function.(old_entry)
                # store the modified entry into the todo-list entries
                new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
                # update todo-list
                %TodoList{ todo_list | entries: new_entries }
        end

        def delete_entry(todo_list, entry_id) do
            %TodoList{ todo_list | entries: Map.delete(todo_list.entries, entry_id) }
        end
end

todo_list = TodoList.new()
    |> TodoList.add_entry(%{ date: ~D[2018-12-19], title: "Dentist" })
    |> TodoList.add_entry(%{ date: ~D[2018-12-20], title: "Shopping" })
    |> TodoList.add_entry(%{ date: ~D[2018-12-19], title: "Movies" })

entries = TodoList.entries(todo_list, ~D[2018-12-19])
IO.inspect(entries)
