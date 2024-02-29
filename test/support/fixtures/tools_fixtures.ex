defmodule App.ToolsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Tools` context.
  """

  @doc """
  Generate a tool.
  """
  def tool_fixture(attrs \\ %{}) do
    {:ok, tool} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> App.Tools.create_tool()

    tool
  end
end
