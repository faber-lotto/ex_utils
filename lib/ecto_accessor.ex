defmodule ExUtils.Ecto.Accessor do

  @moduledoc """
    Contains common queries.
  """

  defmacro __using__([]) do
    raise "You need to provide a model when using #{__MODULE__}!"
  end

  defmacro __using__([repo: repo, model: resource]) do
    quote location: :keep do
      import Ecto.Query

      def get(id) do
        repo_apply(:get, [unquote(resource), id])
      end

      def get_by(keyword) do
        repo_apply(:get_by, [unquote(resource), keyword])
      end

      def all_by(keyword) do
        repo_apply(:all, [(from q in unquote(resource), where: ^keyword)])
      end

      def all do
        repo_apply(:all, [from entry in unquote(resource)])
      end

      def count do
        repo_apply(:count, [unquote(resource)])
      end

      def delete(entry) do
        repo_apply(:delete, [entry])
      end

      def join(assoc), do: join(unquote(resource), assoc)
      def join(query, assoc) do
        from q in query,
          left_join: p in assoc(q, ^assoc),
          preload: [{^assoc, p}]
      end

      def delete!(entry) do
        repo_apply(:delete!, [entry])
      end

      def delete_all do
        repo_apply(:delete_all, [unquote(resource)])
      end

      def create(params) do
        changeset = unquote(resource).changeset(params)
        repo_apply(:insert, [changeset])
      end

      def create!(params) do
        changeset = unquote(resource).changeset(params)
        repo_apply(:insert!, [changeset])
      end

      def update(entry, params) do
        changeset = unquote(resource).changeset(entry, params)
        repo_apply(:update, [changeset])
      end

      def update!(entry, params) do
        changeset = unquote(resource).changeset(entry, params)
        repo_apply(:update!, [changeset])
      end

      defp repo_apply(fun, args) do
        apply(unquote(repo), fun, args)
      end

      defoverridable [get: 1, get_by: 1, all_by: 1, all: 0, create: 1,
                      create!: 1, join: 1, join: 2, delete: 1, delete!: 1,
                      delete_all: 0, update: 2, update!: 2]
    end
  end
end
