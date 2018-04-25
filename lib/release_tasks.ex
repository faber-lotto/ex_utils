defmodule ExUtils.ReleaseTasks do
  @moduledoc """
  Tasks which have to be available in releases (e.g. migrations)
  """

  defmacro __using__(_) do
    quote do
      import ExUtils.ReleaseTasks

      def migrate(app, version, tags) do
        priv_path = Application.app_dir(app, "priv")
        Application.get_all_env(app)[:ecto_repos]
        |> Enum.each(fn(repo) ->
          migration_path = "#{priv_path}/#{repo_dir(repo)}/migrations"
          case repo.__adapter__.storage_up(repo.config) do
            :ok ->
              IO.puts "The database for #{repo} has been created"
              migrate_repo(repo, tags[version][repo], migration_path)
            {:error, :already_up} ->
              IO.puts "The database for #{repo} has already been created"
              migrate_repo(repo, tags[version][repo], migration_path)
            {:error, term} when is_binary(term) ->
              raise "The database for #{repo} couldn't be created: #{term}"
            {:error, term} ->
              raise "The database for #{repo} couldn't be created: #{term}"
          end
        end)
      end
    
      def migrate_to_last_version(app, tags) do
        migrate(app, last_version(tags), tags)
      end
    
      defp last_version(tags) do
        Map.keys(tags)
        |> Enum.sort(&(&1 > &2))
        |> List.first
      end
    
      defp direction(repo, target_state) do
        current_state = (Ecto.Migrator.migrated_versions(repo) |> List.last) || 0
        IO.puts "current_state = #{inspect current_state}"
        IO.puts "target_state = #{inspect target_state}"
        cond do
          target_state == nil -> nil
          current_state == target_state -> nil
          current_state > target_state -> :down
          current_state < target_state -> :up
        end
      end
    
      defp migrate_repo(repo, nil, path), do: nil
      defp migrate_repo(repo, target_state, path) do
        if direction = direction(repo, target_state) do
          IO.puts "migrating #{inspect repo} in direction #{inspect direction}"
          Ecto.Migrator.run(repo, path, direction, to: target_state + 0.1)
        end
      end
    
      defp repo_dir(repo) do
        Macro.underscore(repo)
        |> String.split("/")
        |> List.last
      end
    end
  end
end
