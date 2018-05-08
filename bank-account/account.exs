defmodule BankAccount do
  use GenServer

  @moduledoc """
  A bank account that supports access from multiple processes.
  """
  defstruct balance: 0, status: :open

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = GenServer.start_link(__MODULE__, %__MODULE__{})
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    GenServer.call(account, :close)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    GenServer.call(account, :current_balance)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    GenServer.call(account, {:update, amount})
  end

  def handle_call(_, _from, %__MODULE__{status: :closed}=state) do
    {:reply, {:error, :account_closed}, state}
  end

  def handle_call(:current_balance, _from, %__MODULE__{balance: balance}=state) do
    {:reply, balance, state}
  end
  
  def handle_call({:update, amount}, _from, %__MODULE__{balance: balance}=state) do
    new_balance = balance + amount
    {:reply, new_balance, %{ state | balance: new_balance }}
  end

  def handle_call(:close, _from, %__MODULE__{}=state) do
    {:reply, nil, %{ state | status: :closed }}
  end
end
