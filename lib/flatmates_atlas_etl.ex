defmodule FlatmatesAtlasEtl do
  @base_url           System.get_env("ELASTICSEARCH_BASE_URL")
  @key_id             System.get_env("AWS_ES_KEY_ID_PROD")
  @secret_access_key  System.get_env("AWS_ES_SECRET_ACCESS_KEY_PROD")
  @region             System.get_env("AWS_REGION")
  @service            System.get_env("AWS_SERVICE")
  @method             "GET"

  def indices do
    with { :ok, _ } <- AtlasRepository.download_archive(),
         { :ok, csvfile } <- ZipService.unzip() do
      File.stream!(csvfile)
      |> CSV.decode(headers: true)
      |> Flow.from_enumerable()
      |> Flow.map(& elem(&1, 1))
      |> Enum.to_list
      |> IO.inspect
    else
      { :error, reason } -> &(IO.inspect &1)
    end
  end

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
