defmodule Mix.Tasks.Gen.Supervisor do
  @moduledoc ~S"""
  This task is intended to create a Supervisor template
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

  @supervisor_template "templates/supervisor.eex"

  @shortdoc "Creates a Supervisor file in the given path with the appropriate module name"

  def run([]), do: IO.puts("You need to enter a path as an argument.")
  def run([path | _]) do
    CLI.main(path, @supervisor_template)
  end

end
