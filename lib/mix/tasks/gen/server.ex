defmodule Mix.Tasks.Gen.Server do
  @moduledoc ~S"""
  This task is intended to create a GenServer template
  with the module name given as a path in the parameters.

  *Note: The path has to comply with the Elixir naming conventions.*

  ## Examples of Usage
      mix gen.server [path]

  Where [path] should be a valid module path. A valid module path should:
  * have files and folders snake cased
  * end with the *.ex* extension
  """

  use Mix.Task

  alias ElixirMixGen.CLI

  @server_template "templates/server.eex"

  @shortdoc "Creates a GenServer file in the given path with the appropriate module name"

  def run([]), do: IO.puts("You need to enter a path as an argument.")
  def run([path | _]) do
    CLI.main(path, @server_template)
  end

end
