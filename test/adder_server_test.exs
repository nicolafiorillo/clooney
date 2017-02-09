defmodule AdderServerTest do
  use ExUnit.Case
  doctest Clooney

  test "adding correctly" do
    {:ok, pid} = AdderServer.start(10)
    AdderServer.add(pid, 3)
    assert AdderServer.state(pid) == 13
  end

  test "clooney add numbers correctly" do
    # IO.inspect AdderClooneyServer.module_info
    # IO.inspect AdderClooneyServer.__info__(:functions)

    {:ok, pid} = AdderClooneyServer.start(10)
    AdderClooneyServer.add(pid, 3)
    assert AdderClooneyServer.state(pid) == 13
  end

  test "clooney add lists correctly" do
    {:ok, pid} = AdderClooneyServer.start([10])
    AdderClooneyServer.append(pid, [12, 14])
    assert AdderClooneyServer.state(pid) == [10, 12, 14]
  end

  test "clooney as_string correctly" do
    {:ok, pid} = AdderClooneyServer.start(1)
    assert "2" == AdderClooneyServer.as_string(pid, 2)
    assert AdderClooneyServer.state(pid) == "2"
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

  defmessage add(pid, value) do
    state(pid) + value
  end

  defmessage append(pid, value) do
    state(pid) ++ value
  end

  defmessage as_string(pid, value) do
    "#{inspect value}"
  end
end
