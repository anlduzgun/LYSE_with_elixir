defmodule KittyServer do
  @moduledoc """
  Documentation for `KittyServer`.
  """
  #import cat sturct
  import Cat
  
  #Client API
  def start_link() do
    spawn_link(fn -> init() end)
  end
  
  #Syncronous call
  def order_cat(pid, name, color, description) do
    ref = Process.monitor(pid)
    send(pid, {self(), ref,{:order, name, color, description}})

    receive do
      {^ref, cat} -> Process.demonitor(ref, [:flush])
        cat
      
      {:DOWN, ^ref, :process, ^pid, reason} -> raise(reason)

      after 5000 ->
        raise "timeout"
    end
  end
  
  #This call is asyncronous
  def return_cat(pid, cat = %Cat{}) do
    send(pid, {:return, cat})
    :ok
  end
  
  #Syncronous call
  def close_shop(pid) do
    ref = Process.monitor(pid)
    send(pid,{self(), ref, :terminate})
    
    receive do
      {^ref, :ok} -> Process.demonitor(ref, [:flush])
        :ok
      
      {:DOWN, ^ref, :process, ^pid, reason} -> raise(reason)

      after 5000 -> raise "timeout"
    end  
  end
  
  def init(), do: loop([])

  def loop(cats) do
      receive do
        
        {pid, ref, {:order, name, color, description}} ->
          case cats do
            [] -> 
              send(pid, {ref, make_cat(name, color ,description)})
              loop(cats)
            [cat | rest] ->
              send(pid, {ref, cat})
              loop(rest) 
            end

        {:return, cat = %Cat{}} -> 
          loop([cat | cats])
        
        {pid, ref, :terminate} -> 
          send(pid, {ref, :ok})          
          terminate(cats)
        
        unknown -> 
          IO.puts("Unknown message: #{unknown}")
   
     end 
  end

  defp make_cat(name, color, description), do: %Cat{name: name, color: color, description: description }
  
  defp terminate(cats), do: Enum.each(cats, fn(cat) -> IO.puts("#{cat.name} was set free.") end)
    

 end
