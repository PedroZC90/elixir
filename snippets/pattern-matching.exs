import ExUnit.Assertions

# MATCH OPERATOR

# format: a = b
# description: test if the left-side match the right-side

# match the variable 'person' to the right-side term,
# a varible always matches the right-side, and it becomes bound to the value
person = { "Bob", 25 }
IO.inspect(person, label: "person")

## Tuple
{ name, age } = { "Bob", 25 }
assert(name === "Bob")
assert(age === 25)

{ date, time } = :calendar.local_time()
{ year, month, day } = date
{ hour, minute, second } = time
assert(is_tuple(date) &&
    is_number(year) &&
    is_number(month) &&
    is_number(day))

assert(is_tuple(time) &&
    is_number(hour) &&
    is_number(minute) &&
    is_number(second))

## MATCHING CONSTANTS
person = { :person, "Bob", 25 }
IO.inspect(person, label: "person")

{ :person, name, age } = { :person, "Bob", 25 }
assert(name === "Bob")
assert(age === 25)

IO.inspect(File.cwd!, label: "cwd")

{ :ok, content } = File.read("../README.md")
assert(is_bitstring(content))

{ :error, reason } = File.read("../HELLO_WORLD.md")
assert(reason === :enoent)

## VARIABLES IN PATTERNS

# if you are not interested in storing date into a variable,
# we can use an anonymous variable '_'
{ _, time } = :calendar.local_time()
assert(is_tuple(time))

{ _, { hour, _, _ } } = :calendar.local_time()
assert(is_number(hour))

# variable multiple use if the same value repeats
{ amount, amount, amount } = { 127, 127, 127 }
assert(amount === 127)

assert_raise(MatchError, fn () -> { amount, amount, amount } = { 127, 127, 1 } end)

## PIN OPERATOR (^)

expected_name = "Bob"

# '^expected_name' means that you expect the value of the variable
# 'expected_name' to be in the appropriate position in the right-side
# this do not bound the value to the variable expected_name
assert({ ^expected_name, _ } = { "Bob", 25 })
assert_raise(MatchError, fn () -> { ^expected_name, _ } = { "Alice", 30 } end)

## LISTS

[ first, second, third ] = [ 1, 2, 3 ]
assert(first === 1)
assert(second === 2)
assert(third === 3)

[ first, first, first ] = [ 1, 1, 1 ]
assert(first === 1)

[ first, second, _ ] = [ "a", "b", "c" ]
assert(first === "a")
assert(second === "b")

[ head | tail ] = [ 1, 2, 3 ]
assert(head === 1)
assert(tail === [ 2, 3 ])

[ min | _ ] = Enum.sort([ 3, 4, 2, 1])
assert(min === 1)

## MAPS

%{ name: name, age: age } = %{ name: "Bob", age: 25 }
assert(name === "Bob" && age === 25)

# left-side does not need to contains all the keys from the right-side
%{ age: age } = %{ name: "Bob", age: 25 }
assert(age === 25)

# match will fail if the pattern contains a key that's not in the matched
assert_raise(MatchError, fn () ->
  %{ age: age, works_at: works_at } = %{ name: "Bob", age: 25 }
  assert(age === 25)
  assert(is_nil(works_at))
end)

## BITSTRING / BINARY
binary = <<1, 2, 3>>

# extract individual bytes to separate variables
<<b1, b2, b3>> = binary
assert(b1 === 1)
assert(b2 === 2)
assert(b3 === 3)

# extract the first element to a separate variable
# and the rest of the binary into another variable
<<b1, rest :: binary>> = binary
assert(is_number(b1) && b1 === 1)
assert(is_binary(rest) && rest === <<2, 3>>)

# extract separate bits or groups of bits
# e.g: splits a single byte into two 4-bit values
#      the number 155 in binary is represented as 10011011,
#      'a' gets the first 4 bits so 'a' representes 1001 which is equal to number 9
#      'b' gets the last 4 bits so 'b' representes 1011 which is equal to number 11
<<a :: 4, b :: 4>> = <<155>>
assert(155 === 0b10011011)
assert(is_number(a) && a === 9 && a === 0b1001)
assert(is_number(b) && b === 11 && b === 0b1011)

## BINARY STRING
<<b1, b2, b3>> = "ABC"
assert(is_number(b1) && b1 === 65)
assert(is_number(b2) && b2 === 66)
assert(is_number(b3) && b3 === 67)

command = "ping elixir-lang.org"
"ping " <> url = command
assert(is_bitstring(url) && url === "elixir-lang.org")

## COMPOUND MATCHES

# nested match
[ _, { name, _ }, _ ] = [{ "Bob", 25 }, { "Alice", 30 }, { "John", 35 }]
assert(is_bitstring(name) && name === "Alice")

# chaining match
a = (b = 1 + 3)
assert(is_number(b) && b === 4)
assert(is_number(a) && a === b)

date_time = {_, { hour, _, _ }} = :calendar.local_time()
assert(is_tuple(date_time))
assert(is_number(hour))

{_, { ^hour, _, _ }} = date_time = :calendar.local_time()
assert(is_tuple(date_time))

## FUNCTIONS
defmodule Rectangle do
    def area({a, b}) do
        a * b
    end
end

assert(Rectangle.area({2, 3}) === 6)

# raise an error because function requires a two-element tuple
assert_raise(FunctionClauseError, fn () -> Rectangle.area(2) end)

## MULTICLAUSE FUNCTION
defmodule Geometry do
    def area({ :rectangle, a, b }) do
        a * b
    end

    def area({ :square, a }) do
        a * a
    end

    def area({ :circle, r }) do
        :math.pi() * :math.pow(r, 2)
    end

    def area(unknown) do
        { :error, { :unknown_shape, unknown } }
    end
end

assert(Geometry.area({ :rectangle, 4, 5 }))
assert(Geometry.area({ :square, 5 }))
assert(Geometry.area({ :circle, 4 }))
# assert_raise(FunctionClauseError, fn () -> Geometry.area({ :rectangle, 1, 2, 3 }) end)

# create a function value with the capture operator '&'
# e.g: &Module.fun/arity
fun = &Geometry.area/1
assert(fun.({ :square, 5 }))
assert(fun.({ :circle, 4 }))

{ :error , reason } = Geometry.area({ :triangle, 1, 2, 3 })
assert(is_tuple(reason))
assert({ :unknown_shape, _tuple } = reason)

# GUARDS
defmodule TestNumber do
    # version 1
    def test(v) when v > 0, do: :positive
    def test(v) when v < 0 do
        :negative
    end
    def test(0) do
        :zero
    end

    # version 2
    def test_v2(v) when is_number(v) and v > 0 do
       :positive
    end
    def test_v2(v) when is_number(v) and v < 0 do
        :negative
    end
    def test_v2(0) do
        :zero
    end
end

assert(TestNumber.test(0) === :zero)
assert(TestNumber.test(1) === :positive)
assert(TestNumber.test(-1) === :negative)

# return true because of elixir types ordering
# number < atom < reference < function < port < pid < tuple < map < list < bitstring
assert(TestNumber.test(:not_a_number) === :positive)

assert(TestNumber.test_v2(-2) === :negative)
assert_raise(FunctionClauseError, fn () -> TestNumber.test_v2(:not_a_number) end)

defmodule ListHelper do
    def smallest(list) when length(list) > 0 do
        Enum.min(list)
    end
    def smallest(_), do: { :error, :invalid_argument }
end

list = [5, 3, 10, -1]
assert(ListHelper.smallest(list) === -1)
assert({ :error, :invalid_argument } = ListHelper.smallest([]))
assert({ :error, :invalid_argument } = ListHelper.smallest(123))

# MULTICLAUSE LAMBDAS

double = fn (v) -> 2 * v end
assert(double.(3) === 6)

test_num = fn
    (v) when is_number(v) and v > 0 -> :positive
    (v) when is_number(v) and v < 0 -> :negative
    (0) -> :zero
end

assert(test_num.(0) === :zero)
assert(test_num.(1) === :positive)
assert(test_num.(-1) === :negative)
