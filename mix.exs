defmodule Exs.MixProject do
  use Mix.Project
  @desc """
     exs is a command line tool. Used to run an exs/ex file. 
  """

    def project do
    [
      app: :exs,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: Exs.CLI],
      description: @desc,
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :mix]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["guidao"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/guidao/exs"
      }
    ]
  end
end
