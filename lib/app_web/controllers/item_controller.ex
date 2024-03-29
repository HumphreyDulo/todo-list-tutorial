defmodule AppWeb.ItemController do
  use AppWeb, :controller

  alias App.Todo
  alias App.Todo.Item
  import Ecto.Query
  alias App.Repo

  def show(conn, %{"id" => id}) do
    item = Todo.get_item!(id)
    render(conn, "show.html", item: item)
  end


  def index(conn, params) do
    item =
      if not is_nil(params) and Map.has_key?(params, "id") do
        Todo.get_item!(params["id"])
      else
        %Item{}
      end

    render(conn, "index.html",
      items: Todo.list_items(get_person_id(conn)),
      changeset: Todo.change_item(item),
      editing: item,
      filter: Map.get(params, "filter", "all")
    )
  end

  # get the person_id from conn.assigns.person.id
  def get_person_id(conn) do
    case Map.has_key?(conn.assigns, :person) do
      false ->
        0

      true ->
        Map.get(conn.assigns.person, :id)
    end
  end

  def new(conn, _params) do
    changeset = Todo.change_item(%Item{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    item_params = Map.put(item_params, "person_id", get_person_id(conn))

    case Todo.create_item(item_params) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: ~p"/items/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, params) do
    index(conn, params)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Todo.get_item!(id)

    case Todo.update_item(item, item_params) do
      {:ok, _item} ->
        conn
        |> redirect(to: ~p"/items/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Todo.get_item!(id)
    {:ok, _item} = Todo.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: ~p"/items")
  end

  def toggle_status(item) do
    case item.status do
      1 -> 0
      0 -> 1
    end
  end

  def toggle(conn, %{"id" => id}) do
    item = Todo.get_item!(id)
    Todo.update_item(item, %{status: toggle_status(item)})

    conn
    |> redirect(to: ~p"/items")
  end

  def clear_completed(conn, _param) do
    person_id = get_person_id(conn)
    query = from(i in Item, where: i.person_id == ^person_id, where: i.status == 1)
    Repo.update_all(query, set: [status: 2])
    # render the main template:
    index(conn, %{filter: "items"})
  end
end
