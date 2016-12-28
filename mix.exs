defmodule PlugRedirectHttps.Mixfile do
  use Mix.Project

  def project do
    [
      app: :plug_redirect_https,
      version: "0.0.7",
      elixir: "~> 1.0",
      name: "plug_redirect_https",
      source_url: "https://github.com/stocks29/plug_redirect_https",
      homepage_url: "https://github.com/stocks29/plug_redirect_https",
      description: description,
      package: package,
      deps: deps
    ]
  end

  def description do
    """
    Plug to redirect http requests to https requests behind a reverse proxy
    """
  end

  def package do
    [
      maintainers: ["Bob Stockdale"],
      licenses: ["MIT License"],
      links: %{
        "GitHub" => "https://github.com/stocks29/plug_redirect_https.git",
        "Docs" => "http://hexdocs.pm/plug_redirect_https"
      }
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:plug, "~> 1.1"},
      {:earmark, "~> 0.2.1", only: :dev},
      {:ex_doc, "~> 0.11.4", only: :dev}
    ]
  end
end
