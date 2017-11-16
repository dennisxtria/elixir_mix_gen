defmodule ElixirMixGenTest do
  use ExUnit.Case

  alias ElixirMixGen.CLI

  test "can sanitize path" do
    assert CLI.sanitize("a/b/c") == {:error, :invalid_file_extension}
    assert CLI.sanitize("a/b/") == {:error, :invalid_file_extension}
    assert CLI.sanitize("a/b c/c.ex") == {:error, :invalid_path_format}
    assert CLI.sanitize("a/b_c/d.ex") == {:ok, "a/b_c/d.ex"}
    assert CLI.sanitize("a/_b_c/d.ex") == {:error, :invalid_path_format}
    assert CLI.sanitize("a/b__c_d/e.ex") == {:error, :invalid_path_format}
    assert CLI.sanitize("a/b.c/d.exs") == {:error, :invalid_file_extension}

  end

  test "creates and evaluates template" do
    assert CLI.create_and_evaluate("a/b_c/d.ex", "test/templates/test.eex") == "defmodule A.BC.D do end\n"
    assert CLI.create_and_evaluate("a/b c/d.ex", "test/templates/test.eex") == "defmodule A.B c.D do end\n"
    assert CLI.create_and_evaluate("d.ex", "test/templates/test.eex") == "defmodule D do end\n"
    assert CLI.create_and_evaluate("a/b/c", "test/templates/test.eex") == "defmodule A.B.C do end\n"
  end

  test "can create file" do
    path = "a/b/c.ex"
    content = "defmodule A.B.C do end\n"

    assert :ok = CLI.create_file(path, content)
    assert {:ok, ^content} = File.read("lib/#{path}")
    assert {:ok, _} = File.rm_rf("lib/a")
  end

end
