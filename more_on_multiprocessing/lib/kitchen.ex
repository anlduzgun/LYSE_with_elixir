defmodule Kitchen do
  @moduledoc """
  Documentation for `Kitchen`.
  """

  def start(foodlist) do
    spawn(fn -> __MODULE__.fridge2(foodlist) end)
  end

  def store(pid, food) do
    send(pid, {self(), {:store, food}})
    receive do
      {^pid, msg} -> 
        msg
    end
  end

  def take(pid, food) do
    send(pid, {self(), {:take, food}})
    receive do
      {^pid, msg} -> 
        msg
    end 
  end


  def store2(pid, food) do
    send(pid, {self(), {:store, food}})
    receive do
      {^pid, msg} -> 
        msg
    after 3000 ->
        :timeout
    end
  end

  def take2(pid, food) do
    send(pid, {self(), {:take, food}})
    receive do
      {^pid, msg} -> 
        msg
    after 3000 ->
        :timeout
    end 
  end



  @doc """
  fridge1() is called and then the function starts from scratch, without state. 
  You can also see that when we call the process to take food from the fridge, 
  there is no state to take it from and so the only thing to reply is not_found. 
  In order to store and take food items, we'll need to add state to the function.
  """
  def fridge1() do
    
    receive do
      {from, {:store, _food}} -> send(from, {self(), :ok})
        fridge1()
      {from, {:take, _food}} -> send(from, {self(), :not_found})
        fridge1()
      :terminate ->
        :ok
    end
  
  end


  def fridge2(foodlist) do
    receive do
      {from, {:store, food}} -> 
        send(from, {self(), :ok})
        fridge2([food | foodlist])

      {from, {:take, food}} -> 
        cond  do
          Enum.member?(foodlist, food) -> 
            send(from, {self(), {:ok, food}})
            fridge2(List.delete(foodlist, food))
          true -> 
            send(from, {self(), :not_found})
            fridge2(foodlist)
        end
    end
    
    
  end

end
