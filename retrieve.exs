[url] = System.argv()  # "https://www.cde.ca.gov/sp/ch/qandasec5.asp"

#
# Create the Ruby code to import the cites.
#

IO.puts News.CodeGen.ruby_code(url)

# Output JSON
# IO.puts "\n\n"
# News.Article.parse(url) |> Jason.encode!(pretty: true) |> IO.puts()
