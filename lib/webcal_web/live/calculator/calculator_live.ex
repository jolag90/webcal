defmodule WebcalWeb.CalculatorLive do
  use WebcalWeb, :live_view

  @impl true
  def mount(params, session, socket) do
    pid =
      case Calculator.start_link(:calculator) do
        {:ok, pid} -> pid
        {:error, {:already_started, pid}} -> pid
      end

    if connected?(socket) do
      Process.send_after(self(), :tick, 1_000)
    end

    socket =
      socket
      |> assign(
        calc_pid: pid,
        display: "WeLcOmE!",
        count: 0,
        debug_params: inspect(params),
        debug_session: inspect(session)
      )

    {:ok, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1_000)

    socket =
      socket
      |> assign(:count, socket.assigns.count + 1)

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Calculator LiveView <%= @count %></h1>
    <pre><%= @debug_params %></pre>
    <pre><%= @debug_session %></pre>
    <pre><%= inspect( @calc_pid ) %></pre>

    <div class="calculator">
      <div class="display"> <%= @display %></div>

      <div class="keypad">
        <button class="key" phx-click="key" phx-value-key="1">1</button>
        <button class="key" phx-click="key" phx-value-key="2">2</button>
        <button class="key" phx-click="key" phx-value-key="3">3</button>
        <button class="key" phx-click="key" phx-value-key="+">+</button>
        <button class="key" phx-click="key" phx-value-key="4">4</button>
        <button class="key" phx-click="key" phx-value-key="5">5</button>
        <button class="key" phx-click="key" phx-value-key="6">6</button>
        <button class="key" phx-click="key" phx-value-key="-">-</button>
        <button class="key" phx-click="key" phx-value-key="7">7</button>
        <button class="key" phx-click="key" phx-value-key="8">8</button>
        <button class="key" phx-click="key" phx-value-key="9">9</button>
        <button class="key" phx-click="key" phx-value-key="*">*</button>
        <button class="key" phx-click="key" phx-value-key="0">0</button>
        <button class="key" phx-click="key" phx-value-key=".">,</button>
        <button class="key" phx-click="key" phx-value-key="=">=</button>
        <button class="key" phx-click="key" phx-value-key="/">:</button>
        <button class="key" phx-click="key" phx-value-key="C">clear</button>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("key", %{"key" => "C"}, socket) do
    calc_pid = socket.assigns.calc_pid
    GenServer.stop(calc_pid)
    {:ok, p} = Calculator.start_link(:calculator)

    socket =
      socket
      |> assign(:calc_pid, p)
      |> assign(:count, 0)
      |> assign(:display, Calculator.display(p))

    {:noreply, socket}
  end

  @impl true
  def handle_event("key", %{"key" => key}, socket) do
    calc_pid = socket.assigns.calc_pid
    Calculator.press_key(calc_pid, key)

    socket =
      socket
      |> assign(:count, socket.assigns.count + 1)
      |> assign(:display, Calculator.display(calc_pid))

    {:noreply, socket}
  end
end
