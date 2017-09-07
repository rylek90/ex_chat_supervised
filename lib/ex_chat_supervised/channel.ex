defmodule ExChatSupervised.Channel do
  use GenServer
  alias ExChatSupervised.{Message, ChannelState, Stash}

  def start_link(name) do
    IO.puts("Restarting #{name}")
    GenServer.start_link(__MODULE__, %ChannelState{name: name},name: name)
  end

  # do it better
  def init(state = %ChannelState{ name: name }) do
    members_from_stash = Stash.get(name)
    {:ok, %ChannelState{ state | members: members_from_stash }}
  end

  def join(channel_name, member_name) do
    GenServer.cast(channel_name, {:join, member_name})
  end

  def send_message(channel_name, message = %Message{}) do
    GenServer.cast(channel_name, {:send_message, message})
  end

  def get_members(channel_name) do
    GenServer.call(channel_name, :get_members)
  end

  def handle_call(:get_members, _from, state) do
    {:reply, state.members, state}
  end

  def handle_cast({:join, member_name}, state = %ChannelState{}) do
    updated_members = MapSet.put(state.members, member_name)
    Stash.insert(state.name, member_name)
    IO.puts "[#{state.name}] - #{member_name} joined."
    new_state = %ChannelState{ state | members: updated_members }
    {:noreply, new_state}
  end

  def handle_cast({:send_message, %Message{from: from, body: body}}, state = %ChannelState{name: name, members: members}) do
    case MapSet.member?(members, from) do
      true -> IO.puts "[#{name}] - [#{from}] - #{body}"
      _ -> IO.puts "#{from} needs to join [#{name}] first"
    end
    {:noreply, state}
  end

end
