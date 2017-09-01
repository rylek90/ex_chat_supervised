defmodule ExChatSupervised.ChannelState do
  @enforce_keys [:name]
  defstruct [:name, members: MapSet.new()]
end
