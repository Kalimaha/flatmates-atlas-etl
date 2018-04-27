defmodule ZipServiceTest do
  use ExUnit.Case

  import Mock

  @filelist           ['surrounding_suburbs.csv']
  @atlas_csv_target   System.get_env("ATLAS_CSV_TARGET")
  @atlas_zip_target   System.get_env("ATLAS_ZIP_TARGET")

  test "extracts the content of the zip file" do
    with_mock :zip, [:unstick, :passthrough], [extract: fn(_zip, _opts) -> { :ok, @filelist } end] do
      ZipService.unzip()

      assert called :zip.extract(@atlas_zip_target |> String.to_charlist, cwd: @atlas_csv_target)
    end
  end

  test "returns the name of the extracted file" do
    with_mock :zip, [:unstick, :passthrough], [extract: fn(_zip, _opts) -> { :ok, @filelist } end] do
      assert ZipService.unzip() == { :ok, 'surrounding_suburbs.csv' }
    end
  end

  describe "unzip error" do
    test "forwards the error" do
      with_mock :zip, [:unstick, :passthrough], [extract: fn(_zip, _opts) -> { :error, :enoent } end] do
        assert ZipService.unzip() == { :error, :enoent }
      end
    end
  end
end
