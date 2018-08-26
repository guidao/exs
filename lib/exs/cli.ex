defmodule Exs.CLI do
  def main(args \\[]) do
    opts = [switches: [add: :string, install: :boolean, eval: :boolean]]
    {kv, args, _} = OptionParser.parse(args, opts)
    for {n, v} <- kv do
      case n do
        :add ->
          [name, version] = String.split(v, "@")
          Exs.Dep.add(name, version)
        :install ->
          install()
        :eval ->
          eval_file(Enum.at(args, 0), [])
        _ ->
          :noop
      end
    end
  end

  def eval_file(filename, argv) do
    [{m,_}|_] = Code.compile_file(filename)
    apply(m, :__main__, [argv])
  end

  def install do
    des_dir = Path.join([Exs.Dep.work_dir, "deps", "exs", "0.0.1"])
    src_dir = "_build/dev/lib/exs/"
    System.cmd("cp", ["-rf", src_dir, des_dir])
  end
end
