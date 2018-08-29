defmodule Exs.CLI do
  def main(args \\[]) do
    opts = [switches: [add: :string, install: :boolean,
                       eval: :boolean, list: :boolean,
                       version: :string]]
    {kv, args, _} = OptionParser.parse(args, opts)
    for {n, v} <- kv do
      case n do
        :add ->
            case String.split(v, "@") do
              [name, version] ->
                Exs.Dep.add(name, version)
              [name] ->
                Exs.Dep.add(name, ">= 0.0.0")
            end
        :install ->
          install()
        :eval ->
          eval_file(Enum.at(args, 0), [])
        :list ->
          list("")
        :version ->
          list(v)
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
    des_dir = Path.join([Exs.Util.dep_dir("exs", "0.1.0"), "ebin"])
    if !File.exists?(des_dir) do
      File.mkdir_p!(des_dir)
    end
    spec = Application.spec(:exs)
    keys = [:applications, :description, :modules, :registered, :vsn]
    kvs = Enum.filter(spec, fn {k,_}-> k in keys end)
    app_file = {:application, :exs, kvs}
    modules = Keyword.get(kvs, :modules, [])
    # write module
    Enum.each(modules, fn m ->
      filename = to_string(m) <> ".beam"
      {_, data, _} = :code.get_object_code(m)
      File.write!(Path.join(des_dir, filename), data)
    end)
    # write app file
    erl_app = :io_lib.format("~p.~n", [app_file])
    :file.write_file(Path.join(des_dir, "exs.app"), erl_app)
  end

  def list("") do
    des_dir = Path.join([Exs.Dep.work_dir, "deps"])
    File.ls!(des_dir)
    |> Enum.each(fn dir ->
      IO.puts(dir)
    end)
  end

  def list(name) do
    des_dir = Path.join([Exs.Dep.work_dir, "deps", name])
    with {:ok, dirs} <- File.ls(des_dir) do
      Enum.map(dirs, fn dir -> IO.puts(dir) end)
    end
  end

end
