defmodule Crawlers.MixProject do
  use Mix.Project

  @app :crawlers

  def project do
    [
      app: @app,
      archives: [mix_gleam: "~> 0.6.2"],
      compilers: [:domo_compiler, :gleam] ++ Mix.compilers(),
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        "test.watch": :test
      ],
      aliases: [
        # Or add this to your aliases function
        "deps.get": ["deps.get", "gleam.deps.get"]
      ],
      erlc_paths: [
        "build/dev/erlang/#{@app}/_gleam_artefacts",
      ],
      erlc_include_path: "build/dev/erlang/#{@app}/include",
      # For Elixir >= v1.15.0
      prune_code_paths: false,

    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :logger_file_backend],
      mod: {Crawlers.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:crawly, "> 0.0.0"},
      {:floki, "~> 0.33.0"},

      {:credo, "> 0.0.0"},
      {:dialyxir, "> 1.0.0", runtime: false},

      {:erlyconv, github: "eugenehr/erlyconv"},
      {:httpoison, "~> 1.7"},
      {:jason,     "~> 1.4"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},

      {:domo,         "~> 1.5"},
      {:typed_struct, "~> 0.3.0", runtime: false},

      {:logger_file_backend, "~> 0.0.12"},

      {:gleam_stdlib, "~> 0.33"},
      {:gleeunit,     "~> 1.0"  , only: [:dev, :test], runtime: false},
    ]
  end
end
