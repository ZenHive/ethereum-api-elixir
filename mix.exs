defmodule EthereumApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :ethereum_api,
      version: "0.1.0-b7",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        flags: [
          :unmatched_returns,
          :missing_return
        ]
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
      {:ex_doc, "~> 0.37.3", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:struct, git: "https://github.com/ZenHive/struct_elixir.git", tag: "v0.2.1"},
      {:json_rpc, git: "https://github.com/ZenHive/json_rpc_elixir.git", tag: "v0.8.0"}
    ]
  end
end
