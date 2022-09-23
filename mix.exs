defmodule Crawlers.MixProject do
  use Mix.Project

  def project do
    [
      app: :crawlers,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        "test.watch": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Crawlers.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "> 0.0.0"},
      {:crawly, "~> 0.14.0"},
      {:floki, "~> 0.33.0"},
      {:httpoison, "~> 1.7"},
      {:jason, "~> 1.4"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:typed_struct, "~> 0.3.0", runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
