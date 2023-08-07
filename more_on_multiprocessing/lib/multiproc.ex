defmodule Multiproc do
  
  def sleep(t) do
    receive do
    after t -> :ok
    end 
  end

  """
  In Erlang, the 'flush' function is used to 'flush' (clear) the process mailbox, removing any                                                                               
  messages that are currently present.
  This function is primarily used for debugging purposes when you want to clean 
  the mailbox and see the messages that were accumulated.
  In Elixir, there is no direct equivalent to the 'flush()' function. 
  However, you can achieve similar behavior by using a combination of receive and recursion.
  
  Keep in mind that flushing the mailbox in a production environment is generally not recommended 
  as it can lead to loss of important messages and unintended side effects.
  The 'flush' functionality is more commonly used during development and debugging to observe 
  messages in the process mailbox.
  """

  def flush() do
   receive do
      _ -> flush()
   after 0 ->
        :ok
    end
  end
  
  def important() do
    receive do
      {priority, message} when priority > 10 ->
        [message | important()]
    after 0 -> 
        normal()
    end
  end


  def normal() do
    receive do
      {_, message} ->
        [message | normal()]
    after 0 ->
        []
    end 
  end

  def optimized(pid) do
    ref  = make_ref()
    send(pid, {self(), ref, :hello})
    receive do
      {^pid, ^ref, msg} -> IO.puts(msg)
    end
  end

end
