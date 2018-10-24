defmodule Exs.CLI do
  @callback name() :: String.t()
  @callback desc() :: String.t()
  @callback run(List.t()) :: List.t()

  @cli_module [Exs.CLI.Install, Exs.CLI.Eval, Exs.CLI.List, Exs.CLI.Help]
  def main([]) do
    main(["help"])
    :ok
  end

  def main(argv) do
    [command | argv] = argv

    mod =
      Enum.find(@cli_module, fn x ->
        command == apply(x, :name, [])
      end)

    case mod do
      nil ->
        raise("unknow command " <> to_string(command))

      m ->
        apply(m, :run, [argv])
    end
  end

  def commands do
    @cli_module
  end
end
