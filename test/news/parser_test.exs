alias News.Test
alias News.Parser

defmodule News.ParserTest do
  @moduledoc false
  use ExUnit.Case
  doctest News.Parser


  @title_and_source_url_test_cases [
    %{file: "qandasec5.asp", url: "https://www.cde.ca.gov/sp/ch/qandasec5.asp", title: "Charter School FAQ Section 5", source_url: "https://www.cde.ca.gov"},
    %{file: "qandasec6.asp", url: "https://www.cde.ca.gov/sp/ch/qandasec6.asp", title: "Charter School FAQ Section 6", source_url: "https://www.cde.ca.gov"}
  ]

  Enum.each(@title_and_source_url_test_cases, fn %{file: f, url: url, title: title, source_url: source_url} ->
    test "finds the title in #{f}" do
      document = unquote(f) |> Test.fixture_html!
      url      = unquote(url)

      assert Parser.find_title(document)             == unquote(title)
      assert Parser.find_source_url(URI.parse(url))  == unquote(source_url)
    end
  end)


  @source_name_test_cases [
    %{file: "article279569109.html", url: "https://www.star-telegram.com/news/state/texas/article279569109.html",                              source_name: "Fort Worth Star-Telegram"},
    %{file: "street-racing.html",    url: "https://www.carabinshaw.com/legal-recourse-for-victims-of-san-antonio-street-racing-accident.html", source_name: "Carabin Shaw"},
  ]

  Enum.each(@source_name_test_cases, fn %{file: f, url: url, source_name: source_name} ->
    test "finds the source name in #{f}" do
      document = unquote(f) |> Test.fixture_html!
      url  =     unquote(url)

      assert Parser.find_source_name(document, url) == unquote(source_name)
    end
  end)
end
