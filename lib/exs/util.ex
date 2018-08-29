defmodule Exs.Util do
  @work_dir Path.join([System.user_home!(), ".exs"])
  @tmp_dir Path.join([@work_dir, "tmp"])
  def work_dir do
    @work_dir
  end

  def dep_dir do
    Path.join([work_dir, "deps"])
  end

  def dep_dir(name, version) do
    Path.join([work_dir, "deps", dep_path(to_string(name), version)])
  end

  defp dep_path(name, version) do
    name <> "-" <> version
  end

  def release_dir(name, version) do
    Path.join([work_dir, "tmp/_build/dev/rel/tmp/lib", dep_path(name, version)])
  end
end
