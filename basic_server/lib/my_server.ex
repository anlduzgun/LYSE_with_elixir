defmodule MyServer do

  #Public API
  def start(module, initalState) do
   spawn(fn() -> init(module, initalState) end) 
  end


  def start_link(module, initalState) do
    spawn_link(fn() -> init(module, initalState) end) 
  end



  def call(pid, msg) do
    ref = Process.monitor(pid)
    send(pid, {:sync, self(), ref, msg})
    receive do
      {^ref, reply} -> 
        Process.demonitor(ref, [:flush])
        reply
      
      {:DOWN, ^ref, :process, ^pid, reason} -> 
        raise reason
      
      after 5000 -> 
        raise "timeout"
    end 
  end

  
  def cast(pid, msg), do: send(pid, {:async, msg})

  def reply({pid, ref}, reply), do: send(pid, {ref, reply})

  def init(module, initalState), do: loop(module, module.init(initalState))
  

  def loop(module, state) do
   
    receive do
    {:async, msg} -> loop(module, module.handle_cast(msg, state))
    {:sync, pid, ref, msg} -> loop(module, module.handle_call(msg, {pid, ref}, state))
   end 
  
  end



end
