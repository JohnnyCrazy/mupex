defmodule Mupex.MixProject do
  use Mix.Project

  def project do
    [
      app: :mupex,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Mupex",
      source_url: "https://github.com/JohnnyCrazy/mupex",
      homepage_url: "https://hexdocs.pm/mupex",
      docs: [
        # The main page in the docs
        main: "Mupex",
        extras: ["README.md"]
      ]
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
      {:plug, "~> 1.6.1"},
      {:ex_doc, "~> 0.19-rc", only: :dev, runtime: false}
    ]
  end
end
