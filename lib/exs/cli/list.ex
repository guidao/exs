defmodule Exs.CLI.List do
  def name do
    "list"
  end

  def desc do
    "list package"
  end

  # list all package
  def run([]) do
    des_dir = Path.join([Exs.Dep.work_dir(), "deps"])

    File.ls!(des_dir)
    |> Enum.each(fn dir ->
      IO.puts(dir)
    end)
  end

  # list special package
  def run([h | _]) do
    des_dir = Path.join([Exs.Dep.work_dir(), "deps", name])

    with {:ok, dirs} <- File.ls(des_dir) do
      Enum.map(dirs, fn dir -> IO.puts(dir) end)
    end
  end
end
