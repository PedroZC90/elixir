Code.require_file("todo-list.ex", "#{__DIR__}/practice")
Code.require_file("fraction.ex", "#{__DIR__}/practice")

import ExUnit.Assertions

# DATA ABSTRACTION
# 1. module in charge of abstracting some data (e.g: String, List, Map, etc.).
# 2. module's functions usually expect an instance of the data abstraction as first argument (e.g: List.insert_at(list, position, value)).
# 3. modifier functions return a modified version of the abstraction.
# 4. query functions return some other type of data.

## INTRODUCTION
list = []
list = List.insert_at(list, -1, :a)
list = List.insert_at(list, -1, :b)
list = List.insert_at(list, -1, :c)
list = List.insert_at(list, -1, :d)
assert([:a, :b, :c, :d] = list)

list = List.insert_at(list, 1, :x)
assert([:a, :x, :b, :c, :d] = list)

list = List.insert_at(list, 2, :y)
assert([:a, :x, :y, :b, :c, :d] = list)

## MAP SET
days = MapSet.new()
    |> MapSet.put(:monday)
    |> MapSet.put(:tuesday)
assert(is_map(days))
assert(MapSet.member?(days, :monday))

## TO DO LIST
todo_list = TodoListSimple.new()
    |> TodoListSimple.add_entry(~D[2021-01-08], "Dentist")
    |> TodoListSimple.add_entry(~D[2021-01-09], "Extra Work")
    |> TodoListSimple.add_entry(~D[2021-01-08], "Shopping")

entries = TodoListSimple.entries(todo_list, ~D[2021-01-08])
assert(entries === ["Shopping", "Dentist"])

entries = TodoListSimple.entries(todo_list, ~D[2021-01-10])
assert(entries === [])

# Map Entry ToDoList
todo_list = TodoList.new()
    |> TodoList.add_entry(%{ date: ~D[2021-01-08], title: "Dentist" })
    |> TodoList.add_entry(%{ date: ~D[2021-01-12], title: "Gym" })
assert(is_map(todo_list))

# STRUCTS
one_half = Fraction.new(1, 2)
IO.inspect(one_half, label: "fraction")
assert(is_struct(one_half, Fraction))
assert(is_map(one_half))
assert(one_half.a === 1 and one_half.b === 2)
assert(Fraction.value(one_half) === 0.5)

%{a: a, b: b} = one_half
assert(a === 1 and b === 2)

# this pattern matches any Fraction struct, regardless of the content.
# assert(%Fraction{} = one_half)    # not working on script
assert(%{} = one_half)

one_quarter = %{ one_half | b: 4 }
assert(is_struct(one_quarter, Fraction))
assert(is_map(one_quarter))
assert(Fraction.value(one_quarter) === 0.25)

result = one_half
    |> Fraction.add(one_quarter)
    |> Fraction.value()
IO.inspect(result)
assert(is_number(result))

## STRUCT vs MAP
one_half = Fraction.new(1, 2)

# although structs are maps, some map functionality do not work with structs.
assert_raise(Protocol.UndefinedError,fn () -> Enum.to_list(one_half) end)

list = Enum.to_list(%{a: 1, b: 2})
assert(is_list(list) and list === [a: 1, b: 2])

list = Map.to_list(one_half)
assert(is_list(list) and list === [__struct__: Fraction, a: 1, b: 2])

## PATTERN MATCHING
## Map pattern matchin works by cheicking if ALL FIELDS from the pattern (left-side)
##  exists in the matched term (right-side).
## When matching a map with a struct pattern, it won't work because %Fraction{}
##  contains the fields '__struct__', which isn't present in the plain map matched.
## The oposit works because you match the struct to the %{a: a; b: b},
##  which are present in the Fraction struct

# a struct pattern can't match a plain map
# assert_raise(MatchError, fn () -> %Faction{} = %{a: 1, b: 2} end)

# but a plain map pattern can match a struct
%{a: a, b: b} = Fraction.new(1, 2)
assert(a === 1 and b === 2)

# this code works only in the IEx console.
# assert(%{a: 1, b: 2} = %Fraction{a: 1, b: 2})

## RECORDS

## DATA TRANSPARENCY
todo_list = TodoList.new()
    |> TodoList.add_entry(%{ date: ~D[2021-01-08], title: "Dentist" })
assert(is_map(todo_list))
IO.inspect(todo_list, label: "todo list", structs: false)

mapset = MapSet.new([:monday, :tuesday])
IO.inspect(mapset, label: "mapset")
IO.inspect(mapset, label: "mapset", structs: false)

res = Fraction.new(1, 4)
    |> IO.inspect(label: "1")
    |> Fraction.add(Fraction.new(1, 4))
    |> IO.inspect(label: "2")
    |> Fraction.add(Fraction.new(1, 2))
    |> IO.inspect(label: "3")
    |> Fraction.value()
assert(is_number(res))

# DEEP HIERARCHY

todo_list = %{
    1 => %{ date: ~D[2018-12-19], title: "Dentist"},
    2 => %{ date: ~D[2018-12-20], title: "Shopping"},
    3 => %{ date: ~D[2018-12-19], title: "Movies"}
}
assert(is_map(todo_list))

Kernel.put_in(todo_list[3].title, "Theater")

path = [3, :title]
Kernel.put_in(todo_list, path, "Theater")

## PROTOCOLS
