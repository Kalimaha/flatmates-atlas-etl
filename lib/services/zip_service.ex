defmodule ZipService do

  @atlas_zip_target   System.get_env("ATLAS_ZIP_TARGET")
  @atlas_csv_target   System.get_env("ATLAS_CSV_TARGET")

  def unzip do
    with { :ok, filelist } <- extract() do
      { :ok, Enum.at(filelist, 0) }
    else
      { :error, reason } -> { :error, reason }
    end
  end

  defp extract do
    @atlas_zip_target
    |> String.to_charlist
    |> :zip.extract(cwd: @atlas_csv_target)
  end
end
