defmodule Bot.MixProject do
  use Mix.Project

  def project do
    [
      app: :bot,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Bot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_gram, "~> 0.14.0"},
      {:tesla, "~> 1.3.3"},
      {:gun, "~> 1.3"},
      {:jason, "~> 1.2"},
      {:persist, in_umbrella: true},
      {:elixir_wit, "~> 2.0.0"},
      {:idna, "~> 6.0.0"}
      # {:sibling_app_in_umbrella, in_umbrella: true}
    ]
  end
end
