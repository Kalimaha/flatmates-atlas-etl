defmodule ElixirAtlasEtl do
  @base_url "https://search-elasticsearch-production-nbhi2yq5ffhqssgfvhgqwjdupy.ap-southeast-2.es.amazonaws.com/"
  @key_id System.get_env("AWS_ES_KEY_ID_PROD")
  @secret_access_key System.get_env("AWS_ES_SECRET_ACCESS_KEY_PROD")
  @region "ap-southeast-2"
  @service "es"
  @method "GET"

  def indices do
    IO.inspect get("_cat/indices?v")
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
