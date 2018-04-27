defmodule AtlasRepository do

  @atlas_zip_source System.get_env("ATLAS_ZIP_SOURCE")
  @atlas_zip_target System.get_env("ATLAS_ZIP_TARGET")

  def download_archive do
    with  { :ok, response } <- HTTPoison.get(@atlas_zip_source),
          :ok               <- File.write(@atlas_zip_target, response.body) do
      { :ok, @atlas_zip_target }
    else
      { :error, reason } -> { :error, reason }
    end
  end
end
