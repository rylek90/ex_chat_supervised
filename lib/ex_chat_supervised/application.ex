defmodule ExChatSupervised.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def test do

    ExChatSupervised.Channel.send_message(:some_key, %ExChatSupervised.Message{from: "dupa", body: "some_key"})
    ExChatSupervised.Channel.join(:some_key, "dupa")
    ExChatSupervised.Channel.send_message(:some_key, %ExChatSupervised.Message{from: "dupa", body: "some_key"})
    Process.sleep(100)
    pid = Process.whereis(:some_key)
    Process.exit(pid, :kill)
    Process.sleep(100)
    ExChatSupervised.Channel.send_message(:some_key, %ExChatSupervised.Message{from: "dupa", body: "some_key"})
  end

  def start(_type, _args) do
    import Supervisor.Spec
    ets_table = :ets.new(:members_registry, [:public, :set])
    # List all child processes to be supervised
    children = [
      worker(ExChatSupervised.Stash, [ets_table])
      # worker(ExChatSupervised.Channel, [:some_key, []]),

      # Starts a worker by calling: ExChatSupervised.Worker.start_link(arg)
      # {ExChatSupervised.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExChatSupervised.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
