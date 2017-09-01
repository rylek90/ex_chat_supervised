defmodule ExChatSupervisedChannelTest do
  use ExUnit.Case
  alias ExChatSupervised.{Stash, Channel}

  setup do
    ExChatSupervised.Application.start(:a_wez, :spadaj)
    Stash.clean()
    :ok
  end

  test "after joining new member he should appear in stash too" do
    Channel.join(:random, :some_member)
    assert Channel.get_members(:random) == MapSet.new([:some_member])
    assert Stash.get(:random) == MapSet.new([:some_member])
  end

  test "channel should restore members after failure" do
    Channel.join(:random, :some_member)
    Channel.join(:random, :other_member)

    assert Channel.get_members(:random) == MapSet.new([:some_member, :other_member])

    pid = Process.whereis(:random)
    Process.sleep(100)
    Process.exit(pid, :kill)
    Process.sleep(100)

    assert Channel.get_members(:random) == MapSet.new([:some_member, :other_member])
  end
end
