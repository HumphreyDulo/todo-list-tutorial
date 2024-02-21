defmodule App.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :text, :string
      add :person_id, :integer
      add :status, :integer
      add :description, :string
      add :time, :string
      timestamps()
    end
  end
end
