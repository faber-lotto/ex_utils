defmodule ExUtils.Ecto.Repo do
  @moduledoc """
  Temporarily contains postgres repo functions which are not yet available in Ecto.
  """

  defmacro __using__(otp_app: otp_app, adapter: adapter) do
    quote do
      import ExUtils.Ecto.Repo
      use Ecto.Repo, otp_app: unquote(otp_app), adapter: unquote(adapter)

      @doc """
      Count the number of records in the model table
      """
      def count(model) do
        query = "SELECT COUNT(*) FROM \"#{table(model)}\""
        {:ok, %{rows: [[n_rows]]}} = Ecto.Adapters.SQL.query(__MODULE__, query, [])
        n_rows
      end

      def last_id(model) do
        query = "SELECT last_value AS id FROM \"#{table(model)}_id_seq\""
        {:ok, %{rows: [[last_id]]}} = Ecto.Adapters.SQL.query(__MODULE__, query, [])
        last_id
      end

      def import_csv(model, path, options \\ []) do
        file = File.open!(path, [:read])
        fields = IO.read(file, :line)
        |> String.slice(0..-2) |> String.split(Keyword.get(options, :separator, ","))
        |> Enum.map(fn(s) -> "\"" <> s <> "\"" end)
        |> Enum.join(",")
        File.close file
        table = table(model)
        query = ~s(COPY "#{table}"\(#{fields}\) FROM '#{path}' DELIMITER '#{Keyword.get(options, :separator, ",")}' CSV HEADER)
        response = Ecto.Adapters.SQL.query(__MODULE__, query, [], options)
        set_table_id_seq(table, options)
        response
      end

      defp set_table_id_seq(table, options) do
        #check if sequence exists
        query = ~s(SELECT * FROM information_schema.sequences WHERE sequence_name = '#{table}_id_seq' and sequence_catalog = current_database\(\))
        case Ecto.Adapters.SQL.query(__MODULE__, query, [], options) do
          {:ok, %Postgrex.Result{num_rows: 1}} ->
            query = """
              SELECT setval('"#{table}_id_seq"', COALESCE((SELECT MAX(id) FROM "#{table}"), 1), (SELECT MAX(id) IS NOT NULL FROM "#{table}"))
            """
            Ecto.Adapters.SQL.query!(__MODULE__, query, [], options)
          _ -> nil
        end
      end

      defp table(model) do
        model.__schema__(:source)
      end
    end
  end
end
