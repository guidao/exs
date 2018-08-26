# Exs

**TODO: Add description**
- [] 支持启动应用
- [] 支持emacs编辑器

## 使用
```
1. 先clone下来
git clone git@github.com:guidao/exs.git
2. 编译
mix escript.install
3. 创建一个脚本
cat t.ex
defmodule T do
  use Exs, [deps: [%{:name => :cowboy, :version => "1.0.1"}]]

  def main(args) do
    IO.inspect(:cowboy.module_info())
  end
end
4. 执行
exs --eval t.ex
```
