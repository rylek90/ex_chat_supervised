defmodule ExChatSupervised.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def test do

    ExChatSupervised.Channel.send_message(:chuj, %ExChatSupervised.Message{from: "dupa", body: "chuj"})
    ExChatSupervised.Channel.join(:chuj, "dupa")
    ExChatSupervised.Channel.send_message(:chuj, %ExChatSupervised.Message{from: "dupa", body: "chuj"})
    Process.sleep(100)
    pid = Process.whereis(:chuj)
    Process.exit(pid, :kill)
    Process.sleep(100)
    ExChatSupervised.Channel.send_message(:chuj, %ExChatSupervised.Message{from: "dupa", body: "chuj"})
  end

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      worker(ExChatSupervised.Channel, [:chuj, []])
      # Starts a worker by calling: ExChatSupervised.Worker.start_link(arg)
      # {ExChatSupervised.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExChatSupervised.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
