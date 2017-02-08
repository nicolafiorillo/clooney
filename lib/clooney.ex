defmodule Clooney do
  defmacro __using__(_) do
    quote do
      use GenServer
      import Clooney

      def state(pid) do
        GenServer.call(pid, :state)
      end

      def handle_call(:state, _from, state) do
        {:reply, state, state}
      end
    end
  end

  defmacro start(value) do
    quote do
      def start(value) do
        GenServer.start(__MODULE__, value)
      end
    end
  end

end
