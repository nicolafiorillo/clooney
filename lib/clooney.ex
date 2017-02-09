defmodule Clooney do
  defmacro __using__(_) do
    quote do
      use GenServer
      import Clooney

      def start(value) do
        GenServer.start(__MODULE__, value)
      end

      def state(pid) do
        GenServer.call(pid, :state)
      end

      def handle_call(:state, _from, state) do
        {:reply, state, state}
      end
    end
  end

  defmacro defmessage(func = {name, _, arguments}, do: block) do
    # params = Enum.map(arguments, fn {param, _, _} -> param end)

    quote do
      def unquote(name)(unquote_splicing(arguments)) do
        pid = List.first(unquote(arguments))

        # IO.inspect pid
        # IO.inspect "params: #{inspect unquote(params)}"
        # IO.inspect "arguments: #{inspect unquote(arguments)}"
        # IO.inspect unquote(block)
        GenServer.call(pid, {unquote(name), unquote(block)})
      end

      def handle_call({unquote(name), new_state}, _from, state) do
        {:reply, new_state, new_state}
      end
    end
  end
end
