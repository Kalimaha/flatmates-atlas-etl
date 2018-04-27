defmodule FlatmatesAtlasEtl do
  @base_url           System.get_env("ELASTICSEARCH_BASE_URL")
  @key_id             System.get_env("AWS_ES_KEY_ID_PROD")
  @secret_access_key  System.get_env("AWS_ES_SECRET_ACCESS_KEY_PROD")
  @region             System.get_env("AWS_REGION")
  @service            System.get_env("AWS_SERVICE")
  @atlas_zip_source   System.get_env("ATLAS_ZIP_SOURCE")
  @atlas_zip_target   System.get_env("ATLAS_ZIP_TARGET")
  @atlas_csv_target   System.get_env("ATLAS_CSV_TARGET")
  @method             "GET"

  def indices do
    # download()
    # unzip()
    # IO.inspect get("_cat/indices?v")
  end

  # defp download do
  #   { :ok, response } = HTTPoison.get(@atlas_zip_source)
  #   File.write!(@atlas_zip_target, response.body)
  # end

  # defp unzip do
  #   @atlas_zip_target
  #   |> String.to_char_list
  #   |> :zip.extract(cwd: @atlas_csv_target)
  # end

  defp get(url) do
    { :ok, result } = HTTPoison.get("#{@base_url}#{url}", headers(url), [])
    result.body
  end

  defp headers(url) do
    AWSAuth.sign_authorization_header(
      @key_id,
      @secret_access_key,
      @method,
      "#{@base_url}#{url}",
      @region,
      @service,
      Map.new |> Map.put("Content-Type", "application/json")
    )
  end
end
