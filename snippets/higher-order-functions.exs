import ExUnit.Assertions

# HIGHER ORDER FUNCTIONS
user = %{
  "login" => "alice",
  "email" => "alice@email.com",
  "password" => "a1b2c3d4e5",
  "works_at" => "Elixir",
  "created_at" => "2020-01-03"
}

missing_fields = Enum.filter(["login", "email", "password"], fn (key) -> not Map.has_key?(user, key) end)
IO.inspect(missing_fields, label: "missing_fields")
assert(is_list(missing_fields) && missing_fields === [])

sum = Enum.reduce([1, 2, 3], 0, fn (v, acc) -> v + acc end)
IO.inspect(sum, label: "sum")
assert(is_number(sum) && sum === 6)

sum = Enum.reduce([3, 4, 5], 0, &+/2)
IO.inspect(sum, label: "sum")
assert(is_number(sum) && sum === 12)

total = Enum.reduce([1, "not a number", 2, :not_number, 3], 0, fn
    (element, acc) when is_number(element) -> element + acc
    (_, acc) -> acc
end)
IO.inspect(total, label: "total")

defmodule NumHelper do
    def sum_nums(enumerable) do
        Enum.reduce(enumerable, 0, &add_num/2)
    end

    defp add_num(element, acc) when is_number(element), do: element + acc
    defp add_num(_, acc), do: acc
end

total = NumHelper.sum_nums([1, "not a number", 2, :not_number, 3])
IO.inspect(total, label: "total")
