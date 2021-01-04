import ExUnit.Assertions

# CONDITIONAL
defmodule TestNumber do
    def test(v) when v < 0, do: :negative
    def test(0), do: :zero
    def test(_v), do: :positive

    def test_v2(v) do
        if (v === 0), do: :zero
        if (v > 0), do: :positive, else: :negative
    end
end

defmodule TestList do
    def empty?([]), do: true
    def empty?([_|_]), do: false
end

defmodule Polymorphic do
    def double(v) when is_number(v), do: 2 * v
    def double(v) when is_binary(v), do: v <> v
end

assert(Polymorphic.double(3) === 6)
assert(Polymorphic.double("Jar") === "JarJar")

defmodule Fact do
    def fact(0), do: 1
    def fact(n), do: n * fact(n - 1)
end

res = Fact.fact(0)
IO.inspect(res, label: "factorial(0)")
assert(res === 1)

res = Fact.fact(1)
IO.inspect(res, label: "factorial(1)")
assert(res === 1)

res = Fact.fact(5)
IO.inspect(res, label: "factorial(5)")
assert(res)

defmodule ListHelper do
    def smallest(list) when length(list) > 0 do
        Enum.min(list)
    end
    def smallest(_), do: { :error, :invalid_argument }

    def sum([]), do: 0
    def sum([head | tail]), do: head + sum(tail)
end

assert(ListHelper.sum([]) === 0)
assert(ListHelper.sum([1, 2, 3]) === 6)

# IF / UNLESS
if (5 > 3), do: :one
if (5 < 3), do: :one
if (5 > 3), do: :one, else: :two

max = fn (a, b) ->
    if (a >= b), do: a, else: b
end

assert(max.(5, 3) === 5)

max = fn (a, b) ->
    unless (a >= b), do: b, else: a
end

assert(max.(5, 3) === 5)

# COND
max = fn (a, b) ->
    cond do
        a >= b -> a
        true -> b
    end
end

assert(max.(5, 3) === 5)

# CASE
max = fn (a, b) ->
    case (a >= b) do
        true -> a
        false -> b
    end
end

assert(max.(5, 3) === 5)

test = fn (v) ->
    case (v) do
        :one -> 1
        :two -> 2
        _ -> :unknown
    end
end

assert(test.(:one) === 1)
assert(test.(:two) === 2)
assert(test.("one") === :unknown)

# WITH
defmodule Extract do
    defp extract_login(%{ "login" => login }), do: { :ok, login }
    defp extract_login(_), do: { :error, "login not found" }

    defp extract_email(%{ "email" => email }), do: { :ok, email }
    defp extract_email(_), do: { :error, "email not found" }

    defp extract_password(%{ "password" => password }), do: { :ok, password }
    defp extract_password(_), do: { :error, "password not found" }

    def extract_user(user) do
        case (extract_login(user)) do
            { :error, reason } -> { :error, reason }
            { :ok, login } ->
                case (extract_email(user)) do
                    { :error, reason } -> { :error, reason }
                    { :ok, email } ->
                        case (extract_password(user)) do
                            { :error, reason } -> { :error, reason }
                            { :ok, password } -> %{ "login" => login, "email" => email, "password" => password }
                        end
                end
        end
    end

    def extract_user_with(user) do
        with { :ok, login } <- extract_login(user),
             { :ok, email } <- extract_email(user),
             { :ok, password } <- extract_password(user) do
                { :ok, %{ "login" => login, "email" => email, "password" => password } }
        end
    end
end

data = %{
    "login" => "alice",
    "email" => "alice@email.com",
    "password" => "a1b2c3d4e5",
    "works_at" => "Elixir",
    "created_at" => "2020-01-03"
}
IO.inspect(data, label: "data")

res = %{ "login" => login, "email" => email, "password" => password } = Extract.extract_user(data)
assert(is_bitstring(login) && is_bitstring(email) && is_bitstring(password))
IO.inspect(res, label: "extracted")

IO.inspect(Extract.extract_user_with(data), label: "normalized")

{ :error, reason } = Extract.extract_user_with(%{})
assert(reason === "login not found")

{ :error, reason } = Extract.extract_user_with(%{ "login" => "bob@email.com" })
assert(reason === "email not found")

{ :error, reason } = Extract.extract_user_with(%{ "login" => "bob", "email" => "bob@email.com" })
assert(reason === "password not found")
