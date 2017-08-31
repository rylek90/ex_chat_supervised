defmodule ExChatSupervised.Channel do
  use GenServer
  alias ExChatSupervised.Message

  def start_link(name, members) do
    GenServer.start_link(__MODULE__, MapSet.new(members), name: name)
  end

  def init(members) do
    {:ok, members}
  end

  def join(channel_name, member_name) do
    GenServer.cast(channel_name, {:join, member_name})
  end

  def send_message(channel_name, message = %Message{}) do
    GenServer.cast(channel_name, {:send_message, message})
  end

  def handle_cast({:join, name}, members) do
    {:noreply, MapSet.put(members, name)}
  end

  def handle_cast({:send_message, %Message{from: from, body: body}}, members) do
    case MapSet.member?(members, from) do
      true -> IO.puts "[PUT_CHANNEL_NAME_HERE] - [#{from}] - #{body}"
      _ -> IO.puts "#{from} needs to join [PUT_CHANNEL_NAME_HERE] first"
    end
    {:noreply, members}
  end

end
