defmodule ExChatSupervisedStashTest do
  use ExUnit.Case
  alias ExChatSupervised.Stash

  setup do
    ExChatSupervised.Application.start(:a_wez, :spadaj)
    Stash.clean()
    :ok
  end

  test "should maintain stash after failure" do
    Stash.insert(:sample, :jan)
    pid = Process.whereis(Stash)
    Process.sleep(100)
    Process.exit(pid, :kill)
    Process.sleep(100)
    assert Stash.get(:sample) == MapSet.new([:jan])
  end

  test "stash should clear properly" do
    Stash.insert(:sample, :jan)
    Stash.clean()
    assert Stash.get(:sample) == MapSet.new()
  end

  test "stash should store only one entry per member" do
    Stash.insert(:sample, :jan)
    Stash.insert(:sample, :jan)
    assert Stash.get(:sample) == MapSet.new([:jan])
  end

  test "stash should store property for various channels" do
    Stash.insert(:sample, :jan)
    Stash.insert(:example, :pawel)

    assert Stash.get(:sample) == MapSet.new([:jan])
    assert Stash.get(:example) == MapSet.new([:pawel])
  end
end
