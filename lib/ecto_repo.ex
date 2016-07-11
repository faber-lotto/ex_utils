defmodule ExUtils.Ecto.Repo do
 @moduledoc """
 Temporarily contains postgres repo functions which are not yet available in Ecto.
 """

  defmacro __using__(_) do
    quote do
      import ExUtils.Ecto.Repo

      @doc """
      Count the number of records in the model table
      """
      def count(model) do
        query = "SELECT COUNT(*) FROM #{model.__schema__(:source)}"
        {:ok, %{rows: [[n_rows]]}} = Ecto.Adapters.SQL.query(__MODULE__, query, [])
        n_rows
      end
    end
  end
end
