defmodule ExChatSupervised.Stash do
  use GenServer

  def start_link(ets_table) do
    GenServer.start_link(__MODULE__, ets_table, name: __MODULE__)
  end

  def init(ets_table), do: {:ok, ets_table}

  def insert(channel_name, member) do
    GenServer.cast(__MODULE__, {:insert, channel_name, member})
  end

  def get(channel_name) do
    GenServer.call(__MODULE__, {:get, channel_name})
  end

  def clean do
    GenServer.cast(__MODULE__, :clean)
  end

  def handle_cast({:insert, channel_name, member}, ets_table) do
    members = do_get(ets_table, channel_name)
    updated_members = put_member(members, member)
    :ets.insert(ets_table, {channel_name, updated_members})
    {:noreply, ets_table}
  end

  def handle_cast(:clean, ets_table) do
    :ets.delete_all_objects(ets_table)
    {:noreply, ets_table}
  end

  defp put_member([], member), do: MapSet.new([member])
  defp put_member(members, member), do: MapSet.put(members, member)

  def handle_call({:get, channel_name}, _from, ets_table) do
    {:reply, do_get(ets_table, channel_name), ets_table}
  end

  defp do_get(ets_table, channel_name) do
    :ets.lookup(ets_table, channel_name) |> get_members
  end

  defp get_members([{ _channel_name, members }]), do: members
  defp get_members([]), do: MapSet.new()
end
