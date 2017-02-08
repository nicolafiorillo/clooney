defmodule AdderServerTest do
  use ExUnit.Case
  doctest Clooney

  test "adding correctly" do
    {:ok, pid} = AdderServer.start(10)
    AdderServer.add(pid, 3)
    assert AdderServer.state(pid) == 13
  end

  test "adding clooney correctly" do
    # IO.inspect AdderClooneyServer.module_info
    # IO.inspect AdderClooneyServer.__info__(:functions)

    {:ok, pid} = AdderClooneyServer.start(10)
    assert AdderServer.state(pid) == 10
  end
end

defmodule AdderServer do
  use GenServer

  def start(initial_value) do
    GenServer.start(__MODULE__, initial_value)
  end

  def add(pid, addendum), do: GenServer.call(pid, {:add, addendum})
  def state(pid), do: GenServer.call(pid, :state)

  def init(initial_value), do: {:ok, initial_value}

  def handle_call({:add, addendum}, _from, state) do
    new_value = state + addendum
    {:reply, new_value, new_value}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end
end

defmodule AdderClooneyServer do
  use Clooney

  start(1)
end
