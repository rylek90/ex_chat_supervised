defmodule ExChatSupervisedIntegrationTest do
  use ExUnit.Case
  alias ExChatSupervised.{Channel, Application, Message}

  setup do
    Application.start(nil, nil)
    :ok
  end

  def integration_test do
    Channel.send_message(:random, %Message{from: :sample_user, body: "Hello, all"})
    Channel.join(:random, :sample_user)
    Channel.send_message(:random, %Message{from: :sample_user, body: "Hello, all"})
    Channel.send_message(:general, %Message{from: :sample_user, body: "Hello, all"})

    Channel.join(:general, :other_user)
    Channel.send_message(:general, %Message{from: :other_user, body: "Ugabuga"})

    pid_of_random = Process.whereis(:random)
    pid_of_general = Process.whereis(:general)
    Process.sleep(100)
    Process.exit(pid_of_general, :kill)
    Process.exit(pid_of_random, :kill)
    Process.sleep(100)

    Channel.send_message(:general, %Message{from: :sample_user, body: "I'm not on this channel, this message should not be visible"})
    Channel.send_message(:general, %Message{from: :other_user, body: "I'm on this channel message should be visible"})
    Channel.send_message(:random, %Message{from: :sample_user, body: "Should be alright"})
  end
end
