defmodule RelayServer.Handler do
  @moduledoc """
  Telemetry handlers
  """

  def handle_event([:broadway, :processor, :stop], measurements, _metadata, _config) do
    IO.puts("Message handled, took #{measurements.duration}s")
  end
end
