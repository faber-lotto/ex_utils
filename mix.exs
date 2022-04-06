defmodule ExUtils.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_utils,
      version: "2.0.1",
      elixir: "~> 1.13.0",
      elixirc_paths: elixirc_paths(Mix.env),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps() do
    [
      {:poison, "~> 5.0.0"},
      {:ecto_sql, "~> 3.7.0"},
    ]
  end
end
