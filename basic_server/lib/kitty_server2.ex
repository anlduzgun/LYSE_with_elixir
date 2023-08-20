defmodule KittyServer2 do
  import Cat
  import MyServer

  #client api
  def start_link(), do: MyServer.start_link(__MODULE__, [])

  #synchronous call
  def order_cat(pid, name, color, description), do: MyServer.call(pid, {:order, name, color, description}) 

  #asynchronous call
  def return_cat(pid, cat = %Cat{}), do: MyServer.cast(pid, {:return, cat})

  #synchronous call 
  def close_shop(pid), do: MyServer.call(pid, {:terminate})

  #server functions
  def init(), do: []

  def handle_call({:order, name, color, description,}, from, cats) do
   case cats do
     [] -> MyServer.reply(from, make_cat(name, color, description))
        cats
     [head | tail] -> MyServer.reply(from , {head})
        tail
   end
  end
 
  def handle_call(:terminate, from, cats) do
    MyServer.reply(from, :ok) 
    terminate(cats)
  end

  def handle_cast({:retun, cat = %Cat{}}, cats), do: [cat | cats]

  #private functions
  defp make_cat(name, color, description), do: %Cat{name: name, color:  color, description: description }

  defp terminate(cats), do: Enum.each(cats, fn(cat) -> IO.puts("#{cat.name} was set free") end) 


end
