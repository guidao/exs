defmodule Exs.CLI.Eval do
  def run([]) do
    raise("Need a ex file")
  end

  def run([file | argv]) do
    [{m, _} | _] = Code.compile_file(file)
    apply(m, :__main__, [argv])
  end

  def name do
    "eval"
  end

  def desc do
    "eval a ex file"
  end
end
