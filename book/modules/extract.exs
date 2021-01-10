defmodule Extract do
    defmodule User do
        def extract_user(user) do
            case (extract_fields(user)) do
                [] -> {
                    :ok, %{
                        login: user["login"],
                        email: user["email"],
                        password: user["password"]
                    }
                }
                missing_fields -> { :error, "missing fields: #{ Enum.join(missing_fields, ", ")}" }
            end
        end

        defp extract_fields(user) do
            Enum.filter(["login", "email", "password"], fn (key) -> not Map.has_key?(user, key) end)
        end
    end
end
