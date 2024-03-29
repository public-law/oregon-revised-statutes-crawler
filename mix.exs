defmodule Crawlers.MixProject do
  use Mix.Project

  def project do
    [
      app: :crawlers,
      compilers: [:domo_compiler] ++ Mix.compilers(),
      version: "0.1.0",
      elixir: "~> 1.16",
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
      extra_applications: [:logger, :logger_file_backend],
      mod: {Crawlers.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:floki, "~> 0.33.0"},
      {:logger_file_backend, github: "dbii/logger_file_backend", branch: "warn-fix"},

      # Dev tools
      {:credo,          "> 0.0.0"},
      {:dialyxir,       "> 1.0.0", runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},

      {:erlyconv,  github: "dogweather/erlyconv", branch: "manually-fix-cp1006"},
      {:httpoison, "~> 1.7"},
      {:jason,     "~> 1.4"},
      {:curl_ex,   "~> 1.2.0"},

      # Typing and validation
      {:domo,         "~> 1.5"},
      {:typed_struct, "~> 0.3.0", runtime: false},

      # The Crawly framework
      {:crawly, github: "elixir-crawly/crawly", branch: "master"},
    ]
  end
end
