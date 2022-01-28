defmodule ExUtils.Enum do

  defmacro items(item_list) do
     quote do
        def allowed_items(), do: unquote(item_list)
     end
  end

  defmacro __using__(_) do
    quote do
      import ExUtils.Enum

      @behaviour Ecto.Type

      def type, do: :string

      def cast(value) when is_atom(value) do
        cond do
          Enum.member?(allowed_items(), to_string(value)) -> {:ok, value}
          true -> {:error, "Value is not an allowed item."}
        end
      end

      def cast(value) when is_binary(value) do
        cond do
          Enum.member?(allowed_items(), value) -> {:ok, String.to_atom(value)}
          true -> {:error, "Value is not an allowed item."}
        end
      end

      def cast(_), do: {:error, "Value needs to be a string or an atom."}

      def load(value), do: {:ok, String.to_atom(value)}

      def dump(value) when is_atom(value), do: {:ok, Atom.to_string(value)}

      def dump(_), do: {:error, "Value needs to be an atom."}

      def allowed_items(), do: []

      def equal?(value1, value2), do: value1 == value2

      def embed_as(format), do: :self

      defoverridable [allowed_items: 0]
    end
  end

end
