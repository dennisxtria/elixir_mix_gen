defmodule ElixirMixGenTest do
  use ExUnit.Case

  alias ElixirMixGen.CLI

  test "can sanitize path" do
    assert {:error, :invalid_file_extension} = CLI.sanitize("a/b/c")
    assert {:error, :invalid_file_extension} = CLI.sanitize("a/b/")
    assert {:error, :invalid_path_format} = CLI.sanitize("a/b c/c.ex")
    assert {:ok, "a/b_c/d.ex"} = CLI.sanitize("a/b_c/d.ex")
    assert {:error, :invalid_path_format} = CLI.sanitize("a/_b_c/d.ex")
    assert {:error, :invalid_path_format} = CLI.sanitize("a/b__c_d/e.ex")
    assert {:error, :invalid_file_extension} = CLI.sanitize("a/b.c/d.exs")
  end

  test "creates and evaluates template" do
    assert "defmodule A.BC.D do end\n" =
             CLI.create_and_evaluate("a/b_c/d.ex", "test/templates/test.eex")

    assert "defmodule A.B c.D do end\n" =
             CLI.create_and_evaluate("a/b c/d.ex", "test/templates/test.eex")

    assert "defmodule D do end\n" = CLI.create_and_evaluate("d.ex", "test/templates/test.eex")

    assert "defmodule A.B.C do end\n" =
             CLI.create_and_evaluate("a/b/c", "test/templates/test.eex")
  end

  test "can create file" do
    path = "a/b/c.ex"
    content = "defmodule A.B.C do end\n"

    assert :ok = CLI.create_file(path, content)
    assert {:ok, ^content} = File.read("lib/#{path}")
    assert {:ok, _} = File.rm_rf("lib/a")
  end
end
