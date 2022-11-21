# .credo.exs
%{
  configs: [
    %{
      name: "default",
      checks: [
        {Credo.Check.Readability.RedundantBlankLines, false},
      ],
      # files etc.
    }
  ]
}
