defmodule Exs.Load do

  # 1. 把ebin目录加进path里
  # 2. 找到这个项目的依赖，加到path
  # TODO version是否获取正确
  def ensure_path([]) do
    :ok
  end
  def ensure_path([%{:name => name, :version => version}|stack]) do
    version = to_string(version)
    version = find_version(name, version)
    if(version == nil, do: raise("not found:#{name} #{version}"))
    dir = Path.join([Exs.Dep.work_dir, "deps", to_string(name), version])
    true = Code.prepend_path(Path.join([dir, "ebin"]))
    with {:ok, kvs} <- :file.consult(Path.join([dir, "mix.rebar.config"])),
         {:deps, deps} <- Enum.find(kvs, fn {a, _}-> a == :deps end) do
      all_deps = Enum.map(deps, fn {n, _, {_,_,v}} ->
        %{:name => n, :version => "~> " <> to_string(v)}
      end)
      ensure_path(all_deps ++ stack)
    else
      _ ->
        ensure_path(stack)
    end
  end


  def find_version(name, version) do
    name = to_string(name)
    deps_dir = Path.join([Exs.Dep.work_dir, "deps", name])
    cond do
      File.exists?(Path.join([deps_dir, version])) ->
        version
      true ->
        all_version = File.ls!(deps_dir) |> Enum.sort(&(&1 > &2))
        v = Enum.find(all_version, fn dir ->
          case version do
            "" ->
              true
            _ ->
              Version.match?(dir, version)
          end
        end)
        case v do
          nil ->
            Enum.at(all_version, 0)
          _ ->
            v
        end
    end
  end

end
