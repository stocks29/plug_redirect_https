defmodule PlugRedirectHttps.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_redirect_https,
     version: "0.0.3",
     elixir: "~> 1.0",
     name: "plug_redirect_https",
     source_url: "https://github.com/stocks29/plug_redirect_https",
     homepage_url: "https://github.com/stocks29/plug_redirect_https",
     description: description,
     package: package,
     deps: deps]
  end

  def description do
    """
    Plug to redirect http requests to https requests behind a reverse proxy
    """
  end

  def package do
    [ contributors: ["Bob Stockdale"],
    licenses: ["MIT License"],
    links: %{
      "GitHub" => "https://github.com/stocks29/plug_redirect_https.git", 
      "Docs" => "http://hexdocs.pm/plug_redirect_https"
      }]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:plug, "~> 0.12.2"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.7", only: :dev}
    ]
  end
end
