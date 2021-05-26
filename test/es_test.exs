defmodule EsTest do
  use ExUnit.Case
  doctest Es

  test "greets the world" do
    assert Es.hello() == :world
  end
end
