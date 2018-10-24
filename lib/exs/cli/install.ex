defmodule Exs.CLI.Install do
  def name do
    "install"
  end

  def desc do
    "install dependencies. if argv is empty, it install exs self. "
  end

  # install exs
  def run([]) do
    des_dir = Path.join([Exs.Util.dep_dir("exs", "0.1.0"), "ebin"])

    if !File.exists?(des_dir) do
      File.mkdir_p!(des_dir)
    end

    spec = Application.spec(:exs)
    keys = [:applications, :description, :modules, :registered, :vsn]
    kvs = Enum.filter(spec, fn {k, _} -> k in keys end)
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

    IO.puts("install successful")
  end

  # install third-part package from hex.pm
  def run([h | t]) do
    case String.split(h, "@") do
      [name, version] ->
        Exs.Dep.add(name, version)

      [name] ->
        Exs.Dep.add(name, ">= 0.0.0")

      _ ->
        raise("Unknow package: " <> to_string(h))
    end
  end
end
