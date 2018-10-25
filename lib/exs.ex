defmodule Exs do
  @doc """
     exs is a command line tool. Used to run an exs/ex file. 
     you don't need create a project. exs can install/load dependency.
     feature:
     - Support global dependency management.
     example:
     $ exs install httpoison # it will install latest version
     $ cat http.ex
     defmodule THTTP do
       use Exs, deps: [:httpoison]
       def main(argv) do
         HTTPoison.get("http://www.baidu.com") |> IO.inspect
       end
     end
     $ exs eval http.ex
  """


  defmacro __using__(opts) do
    deps = Keyword.get(opts, :deps)

    quote do
      @on_load :load_deps
      def __main__(args) do
        main(args)
      end

      def load_deps do
        deps = [%{:name => :exs, :version => "0.0.1"} | unquote(deps)]
        Exs.Load.load_and_start(deps)
        :ok
      end
    end
  end

  def main(args) do
  end
end
