defmodule KittyGenServer do
  @moduledoc """
  Documentation for `KittyGenServer`.
  """
  import Cat
  use GenServer 

  #Client api
  def start_link(), do: GenServer.start_link(__MODULE__, [], []) 

  #Syncronous call 
  def order_cat(pid, name, color, description), do: GenServer.call(pid, {:order, name, color, description})
  
  #Asyncronous call
  def return_cat(pid, cat = %Cat{}), do: GenServer.cast(pid, {:return, cat})
  
  #Syncronous call
  def close_shop(pid), do: GenServer.call(pid, :terminate)

  #Server functions
  def init([]), do: {:ok, []}

  def handle_call({:order, name, color, description}, _from, cats) do
    case cats do
      
      [] -> 
        {:reply, make_cat(name, color, description), cats}
      
      [head | tail] -> 
        {:reply, head, tail}
        
    end 
  end 
    
  def handle_call(:terminate, _from, cats), do: {:stop, :normal, :ok, cats}
  
  def handle_cast({:return, cat = %Cat{}, cats}), do: {:noreply, [cat | cats]}

  def handle_info(msg, cats) do
    IO.puts("Unexpected massage #{msg}") 
    {:noreply, cats}
  end

  def terminate(:normal, cats) do
   Enum.each(cats, fn cat -> IO.puts("#{cat} was set free") end)
    :ok
  end
  
  #Private functions
  defp make_cat(name, color, description), do: %Cat{name: name, color: color, description: description}

end
