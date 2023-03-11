# .credo.exs
%{
  configs: [
    %{
      name: "default",
      checks: [
        {Credo.Check.Readability.RedundantBlankLines, false},
        {Credo.Check.Readability.VariableNames, false},
      ],
      # files etc.
    }
  ]
}
