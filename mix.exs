defmodule FlatmatesAtlasEtl.MixProject do
  use Mix.Project

  def project do
    [
      app: :flatmates_atlas_etl,
      version: "0.1.0",
      elixir: "~> 1.6.4",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      { :httpoison, "~> 1.0" },
      { :aws_auth, git: "https://github.com/bryanjos/aws_auth.git" },
      { :mock, "~> 0.3.0", only: :test }
    ]
  end
end
