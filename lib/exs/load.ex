defmodule Exs.Load do

  # 1. 把ebin目录加进path里
  # 2. 找到这个项目的依赖，加到path
  # TODO version是否获取正确

  # 给iex用
  def load(name, version) do
    ensure_path([%{:name => name, :version => version}])
    Application.ensure_all_started(to_atom(name))
  end

  def ensure_path([]) do
    :ok
  end

  def ensure_path([%{:name => name, :version => version}|stack]) do
    version = find_version(name, version)
    if(version == nil, do: raise("not found:#{name} #{version}"))
    dir = Path.join([Exs.Dep.work_dir, "deps", to_string(name), version])
    true = Code.prepend_path(Path.join([dir, "ebin"]))
    deps = get_deps(dir)
    ensure_path(deps ++ stack)
  end

  def start_app([]) do
    :ok
  end
  def start_app([%{:name => name}|stack]) do
    Application.ensure_all_started(to_atom(name))
    start_app(stack)
  end

  def to_atom(term) do
    String.to_atom(to_string(term))
  end

  defp find_version(name, version) do
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
              #如果version为空，最选择最高版本
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

  defp get_deps(dir) do
    with {:ok, data} <- read_exs_lock(dir) do
      Tuple.to_list(data)
      |> Enum.at(5)
      |> Enum.map(fn {name, version, _} ->
        %{:name => name, :version => version}
      end)
    else
      _ ->
        []
    end
  end

  defp read_exs_lock(dir) do
    filename = Path.join(dir, "exs.lock")
    case File.exists?(filename) do
      true ->
        {data, _binding} = Code.eval_file(filename)
        {:ok, data}
      _ ->
        {:error, :notfound}
    end
  end


end
