defmodule ElixirMixGenTest do
  use ExUnit.Case
  #doctest Mix.Tasks.Gen.Server

  alias ElixirMixGen.CLI

  # setup do
  #   on_exit(fn ->
  #
  #   end)
  # end

  test "can sanitize path" do
    assert CLI.sanitize("a/b/c") == {:error, :invalid_file_extension}
    assert CLI.sanitize("a/b/") == {:error, :invalid_file_extension}
    assert CLI.sanitize("a/b c/c.ex") == {:error, :invalid_path_format}
    assert CLI.sanitize("a/b_c/d.ex") == {:ok, "a/b_c/d.ex"}
    assert CLI.sanitize("a/_b_c/d.ex") == {:error, :invalid_path_format}
    assert CLI.sanitize("a/b__c_d/e.ex") == {:error, :invalid_path_format}
    assert CLI.sanitize("a/b.c/d.exs") == {:error, :invalid_file_extension}

  end

  # test "can create module name from path" do
  #   assert CLI.create_module_name("project/feature/worker.ex") == {:ok, "Project.Feature.Worker"}
  #   # assert CLI.create_module_name("project\\feature\\worker.ex") == {:ok, "Project.Feature.Worker"}
  #   assert CLI.create_module_name("lib/project/feature/worker.ex") == {:ok, "Project.Feature.Worker"}
  #   assert CLI.create_module_name("project/feature/worker.exs") == {:error, :invalid_extension}
  #   # assert CLI.create_module_name("c:\\project\\feature\\worker.ex") == {:error, :invalid_path}
  #   assert CLI.create_module_name("/mnt/c/project/feature/worker.ex") == {:error, :invalid_path}
  # end
  #
  # test "can evaluate module name" do
  #   server_tpl = CLI.evaluate_module_name("TestModule", "templates/server.eex")
  #   assert String.starts_with?(server_tpl, "defmodule TestModule do") == true
  #
  #   # todo: supervisor
  # end
  #
  # test "can create file" do
  #   path = "project/feature/worker.ex"
  #   content = "defmodule Project.Feature.Worker do end"
  #
  #   assert CLI.create_file(path, content) == :ok
  #   #todo assert that file has been created
  #   #todo assert that content is correct
  #   #todo cleanup
  #
  #
  # end

end
