defmodule ClassGrade do
  defstruct [:grades, :num]
end

defmodule Grades.Server do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def add_grade(student, grade) do
    GenServer.cast(__MODULE__, {:add_grade, student, grade})
  end

  def get_grades() do
    GenServer.call(__MODULE__, :get_grades)
  end

  @impl true
  def init(_) do
    {:ok, %ClassGrade{
      grades: %{},
      num: 0
    }}
  end

  @impl true
  def handle_cast({:add_grade, student, grade}, state) do
    new_state = %ClassGrade{
      grades: Map.put(state.grades, student, grade),
      num: state.num + 1
    }
    {:noreply, new_state}
  end

  @impl true
  def handle_call(:get_grades, _from, state) do
    grades1 = state.grades |> Enum.reduce([],
      fn {n, grade}, acc ->
        [{String.to_atom(n), grade} | acc]
      end
    )
    _grades2 = state.grades |> Map.to_list
    {:reply, grades1, state}
  end

end
