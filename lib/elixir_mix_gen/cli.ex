defmodule ElixirMixGen.CLI do
  @moduledoc """
  The CLI implements the needed procedure that has to be applied to the path
  in order to have a proper formatted path for the module name.

  This module has the following functions: `main/2`, `sanitize/1`, `split_and_check/1`, `join_parts/1`
  `create_module_name/1`, `evaluate_module_name/2`, `create_file/2` and `check_parts/2`.
  """

  @lib "lib"

  def main(path, template) do
    with \
      {:ok, formatted_path} <- sanitize(path)
    do
      server_content = create_and_evaluate(formatted_path, template)
      with \
        :ok <- create_file(formatted_path, server_content)
      do
        IO.puts("File created.")
      else
        {:error, reason} -> IO.puts("Exited with error #{reason}")
      end
    else
      {:error, :invalid_path_format} ->
        IO.puts("It looks like you have entered a path that does not comply with the Elixir naming conventions.")
      {:error, :invalid_file_extension} ->
        IO.puts("It looks like you have entered an invalid extension. The path needs to end with \".ex\".")
    end
  end

  @doc """
  Creates module name and outputs
  """
  def create_and_evaluate(formatted_path, template) do
    formatted_path
    |> create_module_name()
    |> evaluate_module_name(template)
  end

  @doc """
  Splits and checks the structure of the path.
  """
  def sanitize(path) do
    split_path = split_and_check(path)
    with \
      {:extension, ".ex"} <- {:extension, Path.extname(path)},
      {:format, true} <- {:format, is_list(split_path)}
    do
      {:ok, join_parts(split_path)}
    else
      {:extension, _} -> {:error, :invalid_file_extension}
      {:format, false} -> {:error, :invalid_path_format}
    end
  end

  @doc """
  Downcases and splits the path into a list at the path separator.
  """
  def split_and_check(path) do
    path
    |> String.downcase()
    |> Path.rootname()
    |> Path.split()
    |> check_parts([])
  end

  @doc """
  Reverses and joins a list of paths.
  """
  def join_parts(split_path_list) do
    split_path_list
    |> Enum.reverse
    |> Path.join()
    |> Kernel.<>(".ex")
  end

  @doc """
  Creates a camelized module name.
  """
  def create_module_name(path) do
    path
    |> Path.rootname()
    |> Path.split()
    |> Enum.map(fn x -> Macro.camelize(x) end)
    |> Enum.join(".")
  end

  @doc """
  Given the path and the module name, the output is
  the content of the server/supervisor file
  with the appropriate module name created.
  """
  def evaluate_module_name(module_name, template) do
    EEx.eval_file(template, [module_name: module_name])
  end

  @doc """
  The server/supervisor file is created in the path that is given.
  """
  def create_file(path, server_content) do
    output_path = Path.join([@lib, path])
    output_path
    |> Path.dirname()
    |> File.mkdir_p()

    File.write(output_path, server_content)
  end

  @doc """
  Parses the split path, checking that each part
  is correctly formatted, the Elixir way.
  """
  def check_parts([], acc), do: acc
  def check_parts([h | t], acc) do
    with \
      true <- Regex.match?(~r/^[a-z]((\_)*[a-z0-9])*$/, h),
      false <- Regex.match?(~r/__/, h)
    do
      acc = [h | acc]
      check_parts(t, acc)
    else
      _ -> {:error, :invalid_path_format}
    end

  end

end
