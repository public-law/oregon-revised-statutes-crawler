alias News.Article

defmodule News.CodeGen do
  @moduledoc """
  A module for generating code.
  """


  @spec ruby_code(binary) :: binary
  def ruby_code(url) do
    article = Article.parse(url)

    citation_list =
      article.citations
      |> Enum.map_join(",\n    ", fn cite -> "'#{cite}'" end)


    """
    Source.find_or_create_by!(name: "#{article.source_name}", url: "#{article.source_url}")

    NewsImport.add(
      Item.find_or_create_by(
        url:              URI('#{url}').to_s,
        title:            "#{article.title}",
        summary:          "#{article.description}",
        secondary_source: Source.find_by!(name: '#{article.source_name}'),
        published_on:     Date.parse('#{article.date_modified}'),
      ),
      [
        #{citation_list}
      ]
    )
    """
  end
end
