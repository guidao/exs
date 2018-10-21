defmodule Exs.CLI.Help do
  def name do
    "help"
  end
  def desc do
    "print help information"
  end
  def run(argv) do
    Exs.CLI.commands
    |> Enum.map(fn x ->
       "exs " <> apply(x, :name, []) <> "\t# " <> apply(x, :desc, [])
    end)
    |> Enum.each(fn x ->
      IO.puts x
    end)
    :ok
  end
end
