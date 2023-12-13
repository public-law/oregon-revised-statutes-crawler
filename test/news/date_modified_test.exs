alias News.Test
alias News.DateModified


defmodule News.DateModifiedTest do
  @moduledoc false
  use ExUnit.Case
  doctest News.DateModified

  @test_cases [
    %{date: nil,          html: "<html></html>"},
    %{date: nil,          html: "<html><script type='application/ld+json'>{\"dateBorn\": \"2020-01-01\"}</script></html>"},
    %{date: "2020-01-01", html: "<html><script type='application/ld+json'>{\"datePublished\": \"2020-01-01\"}</script></html>"},
    %{date: "2020-01-02", html: "<html><script type='application/ld+json'>{\"datePublished\": \"2020-01-01\", \"dateModified\": \"2020-01-02\"}</script></html>"},
    %{date: "2020-01-01", html: "<html><script type='application/ld+json'>{\"dateModified\": \"2020-01-01\"}</script></html>"},
    %{date: "2023-08-25", html: "<html><script type='application/ld+json'>{\"dateModified\": \"Fri, 2023-08-25 21:16:28\"}</script></html>"},
    %{date: "2023-09-20", html: "<html><script type='application/ld+json'>{\"dateModified\": \"2023-09-20T16:20:21-05:00\"}</script></html>"},
    %{date: "2020-05-19", html: "<html><head><meta property=\"article:published_time\" content=\"2020-05-19T16:20:34+00:00\"></head></html>"}
  ]

  # Create and run a test for each of the @test_cases
  Enum.each(@test_cases, fn %{html: html, date: date} ->
    test "finds the date in #{html}" do
      html_string = unquote(html)
      date_string = unquote(date)

      expected = if is_binary(date_string), do: Date.from_iso8601!(date_string), else: nil

      assert DateModified.parse(html_string) == expected
    end
  end)


  test "article:published_time date source from HTML" do
    document = "duty-to-settlor.html" |> Test.fixture_file!
    assert DateModified.parse(document) == ~D[2020-05-19]
  end
end
