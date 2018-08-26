defmodule Exs.Dep do
  @work_dir Path.join([System.user_home!(), ".exs"])
  @tmp_dir Path.join([@work_dir, "tmp"])
  def work_dir do
    @work_dir
  end

  def add(name, version) do
    if !File.exists?(@work_dir) do
      File.mkdir!(@work_dir)
    end
    fetch(name, version)
  end

  def fetch(name, version) do
    tmp_exs = "
      defmodule Tmp do
        use Mix.Project
        def project do
          [
            app: :tmp,
            version: \"0.0.1\",
            deps: deps()
          ]
        end

        defp deps do
          [
            {:#{name}, \"#{version}\"}
          ]
        end
      end
    "
    try do
      File.mkdir!(@tmp_dir)
      File.write!(Path.join([@tmp_dir, "mix.exs"]), tmp_exs)
      lock = deps_get()
      mv_dep(lock)
    after
      File.rm_rf!(@tmp_dir)
    end
  end

  def deps_get do
    File.cd!(@tmp_dir, fn->
      0 = Mix.shell().cmd("mix deps.get")
      0 = Mix.shell().cmd("mix compile")
      contents = File.read!("mix.lock")
      opts = [file: "mix.lock", warn_on_unnecessary_quotes: false]
      {:ok, quoted} = Code.string_to_quoted(contents, opts)
      {%{} = lock, _binding} = Code.eval_quoted(quoted, opts)
      lock
    end)
  end

  def mv_dep(deps) do
    Enum.map(deps, fn {k,v} ->
      k = Atom.to_string(k)
      {_, _, version, _, _, _, _} = v
      dep_dir = Path.join([@work_dir, "deps", k, version])
      src_dir = Path.join([@tmp_dir, "_build/dev/lib", k, "*"])
      if !File.exists?(dep_dir) do
        File.mkdir_p!(dep_dir)
        0 = Mix.shell().cmd("cp -rf #{src_dir} #{dep_dir}")
      end
    end)
    :ok
  end

  def remove(name, version) do
    dir = Path.join([@work_dir, "deps", Atom.to_string(name), version])
    if File.exists?(dir) do
      File.rmdir!(dir)
    end
  end

end
