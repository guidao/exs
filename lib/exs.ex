defmodule Exs do

  defmacro __using__(opts) do
    deps = Keyword.get(opts, :deps)
    quote do
      @on_load :load_deps
      def __main__(args) do
        main(args)
      end
      def load_deps do
        deps = [%{:name => :exs, :version => "0.0.1"}|unquote(deps)]
        Exs.Load.ensure_path(deps)
        :ok
      end
    end
  end

  def main(args) do
  end
end
