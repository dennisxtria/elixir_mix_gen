defmodule Mix.Tasks.Gen.Server do
  @moduledoc ~S"""
  This task is intended to create a GenServer template
  with the module name given as a path in the parameters.

  *Note: The path has to comply with the Elixir naming conventions.*

  ## Examples of Usage
      mix gen.server this/is/correct.ex

      mix gen.server this/1s.not/c0rrect.ex

      mix gen.server this/1s.not/c0rrect.exs

  This module also has a `run/1` function.
  """

  use Mix.Task

  alias ElixirMixGen.CLI

  @shortdoc "Creates a GenServer file in the given path with the appropriate module name"

  def run([]), do: IO.puts("You need to enter a path as an argument.")
  def run([path | _]) do
    CLI.main(path, "templates/server.eex")
  end

end
