defmodule AppWeb.AuthLive.Login do
  use AppWeb, :live_view

  alias App.Accounts
  alias App.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    changeset = %User{} |> Accounts.change_user_login() |> to_form()

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign(changeset: changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end



 def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Sign in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
      >
        <%!-- <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error> --%>
        <.input field={{f, :email}} type="email" label="Email" required />
        <.input field={{f, :password}} type="password" label="Password" required />

        <:actions>
          <.button phx-disable-with="Signing in..." class="w-full">Log in</.button>
        </:actions>
      </.simple_form>

    </div>
    """
  end
end
