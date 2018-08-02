defmodule Mupex.MixProject do
  use Mix.Project

  def project do
    [
      app: :mupex,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()

      #Docs
      name: "Mupex",
      source_url:
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
      {:ex_doc, "~> 0.18.0", only: :dev, runtime: false}
    ]
  end
end
