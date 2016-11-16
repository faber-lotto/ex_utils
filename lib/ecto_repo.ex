defmodule ExUtils.Ecto.Repo do
  @moduledoc """
  Temporarily contains postgres repo functions which are not yet available in Ecto.
  """

  defmacro __using__(otp_app: otp_app) do
    quote do
      import ExUtils.Ecto.Repo
      use Ecto.Repo, otp_app: unquote(otp_app)

      @doc """
      Count the number of records in the model table
      """
      def count(model) do
        query = "SELECT COUNT(*) FROM #{table(model)}"
        {:ok, %{rows: [[n_rows]]}} = Ecto.Adapters.SQL.query(__MODULE__, query, [])
        n_rows
      end

      def last_id(model) do
        query = "SELECT last_value AS id FROM #{table(model)}_id_seq"
        {:ok, %{rows: [[last_id]]}} = Ecto.Adapters.SQL.query(__MODULE__, query, [])
        last_id
      end

      def import_csv(model, path, options \\ []) do
        file = File.open!(path, [:read])
        fields = IO.read(file, :line) |> String.slice(0..-2)
        File.close path
        table = table model
        query = ~s(COPY #{table}\(#{fields}\) FROM '#{path}' DELIMITER ',' CSV HEADER)
        response = Ecto.Adapters.SQL.query(__MODULE__, query, [], options)
        query = ~s(SELECT setval\('#{table}_id_seq', COALESCE\(\(SELECT MAX\(id\)+1 FROM #{table}\), 1\), false\))
        Ecto.Adapters.SQL.query(__MODULE__, query, [], options)
        response
      end

      defp table(model) do
        model.__schema__(:source)
      end
    end
  end
end
