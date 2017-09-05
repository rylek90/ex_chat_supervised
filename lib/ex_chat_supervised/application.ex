defmodule ExChatSupervised.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias ExChatSupervised.{ChannelState, Stash, Channel}

  def start(_type, _args) do
    import Supervisor.Spec
    ets_table = :ets.new(:members_registry, [:public, :set])
    # List all child processes to be supervised
    children = [
      worker(Stash, [ets_table]),
      worker(Channel, [:random], id: :random),
      worker(Channel, [:general], id: :general),
      worker(Channel, [:homeworks], id: :homeworks)
    ]

    opts = [strategy: :one_for_one, name: ExChatSupervised.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
