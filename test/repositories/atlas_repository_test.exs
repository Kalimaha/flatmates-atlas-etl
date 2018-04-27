defmodule AtlasRepositoryTest do
  use ExUnit.Case

  import Mock

  @atlas_zip_source   System.get_env("ATLAS_ZIP_SOURCE")
  @atlas_zip_target   System.get_env("ATLAS_ZIP_TARGET")
  @atlas_response     %{ body: {} }
  @httpoison_error    %HTTPoison.Error{ id: nil, reason: :econnrefused }
  @disk_error         "Disk full!"

  test "downloads remote zip file" do
    with_mocks([
      { HTTPoison,  [], [get: fn(_) -> { :ok, @atlas_response } end] },
      { File,       [], [write: fn(_target, _content) -> :ok end] }
    ]) do
      AtlasRepository.download_archive()

      assert called HTTPoison.get(@atlas_zip_source)
    end
  end

  test "write remote file to disk" do
    with_mocks([
      { HTTPoison,  [], [get: fn(_) -> { :ok, @atlas_response } end] },
      { File,       [], [write: fn(_target, _content) -> :ok end] }
    ]) do
      AtlasRepository.download_archive()

      assert called File.write(@atlas_zip_target, @atlas_response.body)
    end
  end

  describe "connection error" do
    test "forwards the error" do
      with_mock HTTPoison, [get: fn(_) -> { :error, @httpoison_error } end] do
        assert AtlasRepository.download_archive() == { :error, @httpoison_error }
      end
    end
  end

  describe "disk error" do
    test "forwards the error" do
      with_mocks([
        { HTTPoison,  [], [get: fn(_) -> { :ok, @atlas_response } end] },
        { File,       [], [write: fn(_target, _content) -> { :error, @disk_error } end] }
      ]) do
        assert AtlasRepository.download_archive() == { :error, @disk_error }
      end
    end
  end
end
