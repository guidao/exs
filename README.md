# Exs

**TODO: Add description**
- [ ] 支持启动应用
- [ ] 支持emacs编辑器

## Getting Start
```
$ git clone git@github.com:guidao/exs.git
$ mix escript.install
$ exs install
$ exs install cowboy
$ cat t.ex
defmodule T do
  use Exs, deps: [:cowboy]

  def main(args) do
    IO.inspect(:cowboy.module_info())
  end
end
$exs eval t.ex
```
