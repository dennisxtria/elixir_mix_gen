defmodule ElixirMixGen.CLI do
  @moduledoc """
  The CLI implements the needed procedure that has to be applied to the path
  in order to have a proper formatted path for the module name.

  This module has the following functions: `main/2`, `sanitize/1`, `create_module_name/1`,
  `evaluate_module_name/2`, `create_file/2` and `parser/2`.
  """

  @lib "lib"

  def main(path, template) do
    case sanitize(path) do
      {:ok, formatted_path} ->
        server_content =
          formatted_path
          |> create_module_name()
          |> evaluate_module_name(template)

        with\
         :ok <- create_file(formatted_path, server_content)
        do
          IO.puts("File created.")
        else
          {:error, reason} -> IO.puts("Exit with error #{reason}")
        end
      {:error, :invalid_path_format} -> IO.puts("It looks like you have entered a path that does not comply with the Elixir naming conventions. Please try again.")
      {:error, :invalid_file_extension} -> IO.puts("It looks like you have entered an invalid extension. The path needs to end with the \".ex\" extension.")
    end

  end

  #splits and checks the structure of the path
  def sanitize(path) do
    with \
      ".ex" <- Path.extname(path)
    do
      split_path =
        path
        |> String.downcase()
        |> Path.rootname()
        |> Path.split()
        |> parser([])
      case Kernel.is_list(split_path) do
        true ->
          formatted_path =
            split_path
            |> Enum.reverse
            |> Path.join()
            |> Kernel.<>(".ex")
          {:ok, formatted_path}
        _ -> {:error, :invalid_path_format}
      end
    else
      _ -> {:error, :invalid_file_extension}
    end
  end

  #creates a camelized module name
  def create_module_name(path) do
    path
    |> Path.rootname()
    |> Path.split()
    |> Enum.map(fn x -> Macro.camelize(x) end)
    |> Enum.join(".")
  end

  #given the path and the module name, the output is
  #the content of the server/supervisor file
  #with the appropriate module name created
  def evaluate_module_name(module_name, template) do
    EEx.eval_file(template, [module_name: module_name])
  end

  #the server/supervisor file is created in the path that is given
  def create_file(path, server_content) do
    output_path = Path.join([@lib, path])
    output_path
    |> Path.dirname()
    |> File.mkdir_p()

    File.write(output_path, server_content)
  end

  #parses the split path, checking that each part
  #is correctly formatted, the Elixir way
  def parser([], acc), do: acc
  def parser([h | t], acc) do
    with \
      true <- Regex.match?(~r/^[a-z]((\_)*[a-z0-9])*$/, h),
      false <- Regex.match?(~r/__/, h)
    do
      acc = [h | acc]
      parser(t, acc)
    else
      _ -> {:error, :invalid_path_format}
    end

  end

end
