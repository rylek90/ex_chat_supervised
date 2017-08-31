defmodule ExChatSupervisedTest do
  use ExUnit.Case
  doctest ExChatSupervised

  test "greets the world" do
    assert ExChatSupervised.hello() == :world
  end
end
