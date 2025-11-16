defmodule Name do
  defstruct [:first, :last]

  def new(first, last) do
    %Name{first: first, last: last}
  end
end

defmodule Student do
  defstruct [id: "", Name: %Name{}, scores: %{}]

  def new(id, first_name, last_name, scores \\ %{}) do
    %Student{id: id, name: Namer.new(first_name, last_name), scores: scores}
  end

  def add_scores(s, course, score) do
    %Student{s | scores: Map.put(s.scores, course, score)}
  end
end

# Syntax close to a map
homer = %Name{first: "Homer", last: "Simpson"}

# ! Tip for lab
String.split(" asdfga asdfa sdf")

# Pattern matching
# [id, first, last | rest] ->
