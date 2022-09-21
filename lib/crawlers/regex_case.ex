defmodule RegexCase do
  @moduledoc """
  Creates a Case expression which branches on the result of a Regex match.
  """

  defmacro regex_case(string, do: lines) do
    new_lines =
      Enum.map(lines, fn {:->, context, [[regex], result]} ->
        condition = quote do: String.match?(unquote(string), unquote(regex))
        {:->, context, [[condition], result]}
      end)

    # Base case if nothing matches; "cond" complains otherwise.
    base_case = quote do: (true -> nil)
    new_lines = new_lines ++ base_case

    quote do
      cond do
        unquote(new_lines)
      end
    end
  end
end

# defmodule Run do
#   import RegexCase

#   def run do
#     regex_case "hello" do
#       ~r/x/ -> IO.puts("matches x")
#       ~r/e/ -> IO.puts("matches e")
#       ~r/y/ -> IO.puts("matches y")
#     end
#   end
# end

# Run.run()
