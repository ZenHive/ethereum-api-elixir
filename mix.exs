defmodule EthereumApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :ethereum_api,
      version: "0.1.0-b4",
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
      {:result, git: "git@github.com:ZenHive/result_elixir.git", tag: "v0.4.0", override: true},
      {:option, git: "git@github.com:ZenHive/option_elixir.git", tag: "v0.1.0", override: true},
      {:struct, git: "https://github.com/ZenHive/struct_elixir.git", tag: "v0.1.3"},
      {:json_rpc, git: "https://github.com/ZenHive/json_rpc_elixir.git", tag: "v0.6.1"},
      # {:ex_keccak, "~> 0.7.6"},
      # {:ex_abi, "~> 0.8.3"}
    ]
  end
end
