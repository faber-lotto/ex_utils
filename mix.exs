defmodule ExUtils.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_utils,
     version: "0.0.6",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [{:poison, ">= 3.1.0"}]
  end
end
