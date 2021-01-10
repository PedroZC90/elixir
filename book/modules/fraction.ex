defmodule Fraction do
    defstruct a: nil, b: nil

    @doc """
    Instanciate a new fraction struct.
    """
    def new(a, b) do
        %Fraction{ a: a, b: b }
    end

    @doc """
    Calculate the fraction value.
    """
    def value(%Fraction{ a: a, b: b }) do
        a / b
    end

    @doc """
    Add two fractions.
    """
    def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do
        new(a1 * b2 + a2 * b1, b1 * b2)
    end
end
