defmodule ElixirAtlasEtl.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_atlas_etl,
      version: "0.1.0",
      elixir: "~> 1.6.4",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :httpoison, "~> 1.0" },
      { :aws_auth, git: "https://github.com/bryanjos/aws_auth.git" }
    ]
  end
end
