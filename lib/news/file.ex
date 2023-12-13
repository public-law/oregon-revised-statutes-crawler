defmodule News.File do
  @moduledoc """
  A module for file functions.
  """

  @spec read_pdf_as_html!(binary) :: binary
  def read_pdf_as_html!(input_path) do
    html_temp_file = tmp_file!("tempfile.html")
    System.cmd("mutool", ["convert", "-o", html_temp_file, input_path])
    File.read!(html_temp_file)
  end


  @spec tmp_file!(binary) :: binary
  def tmp_file!(ext_to_match \\ "tempfile.tmp") do
    ext  = Path.extname(ext_to_match)
    dir  = System.tmp_dir!()
    file = "#{System.system_time()}-#{rand()}#{ext}"

    Path.join(dir, file)
  end


  @spec rand() :: pos_integer
  def rand() do
    :rand.uniform(10_000_000_000_000)
  end
end
