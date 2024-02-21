defmodule App.Todo.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :person_id, :status, :text]}
  schema "items" do
    field :person_id, :integer, default: 0
    field :status, :integer, default: 0
    field :text, :string
    field :description, :string
    field :time, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:text, :person_id, :status, :description, :time])
    |> validate_required([:text, :description, :time])
    |> validate_number(:status, greater_than_or_equal_to: 0, less_than_or_equal_to: 2)
    |> validate_length(:text, min: 0)
  end
end
