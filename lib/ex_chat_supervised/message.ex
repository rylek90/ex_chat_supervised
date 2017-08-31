defmodule ExChatSupervised.Message do
  @enforce_keys [:from, :body]
  defstruct [:from, :body]
end
