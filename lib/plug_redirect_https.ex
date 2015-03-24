
defmodule PlugRedirectHttps do
  require Logger

  @proto_header "x-forwarded-proto"
  @host_header "host"

  @moduledoc """
  Redirect http to https behind a load balancer (or other reverse proxy).

  If an X-Forwarded-Proto header is present and it is "http", this plug will
  redirect requests to the https protocol using the Host header with the
  path and query parameters of the current request.

  From the client's perspective the only change should be from http to https.

  Usage is very easy

      plug PlugRedirectHttps
  """

  @doc """
  Initialize this plug. Currently there are no supported options.
  """
  def init(opts) do
    opts
  end

  @doc """
  Call this plug.
  """
  def call(conn, _opts) do
    conn
    |> get_forwarded_protocol 
    |> redirect_to_https?
    |> handle_request(conn)
  end

  defp handle_request(false, conn) do
    Logger.debug("not redirecting to https proxy url. X-Forwarded-Proto is: #{get_forwarded_protocol(conn)}")
    conn
  end
  defp handle_request(true, conn) do
    Logger.debug("redirecting to https proxy url")
    redirect_to_https(conn)
  end

  defp get_forwarded_protocol(conn) do
    Plug.Conn.get_req_header(conn, @proto_header)
    |> List.first
  end

  defp get_forwarded_host(conn) do
    Plug.Conn.get_req_header(conn, @host_header)
    |> List.first
  end

  defp redirect_to_https?("http"), do: true
  defp redirect_to_https?(_proto), do: false
  
  defp redirect_to_https(conn) do
    conn
    |> Plug.Conn.put_resp_header("location", get_current_url_as_proxied_https(conn))
    |> Plug.Conn.resp(302, "")
    |> Plug.Conn.halt
  end

  defp get_current_url_as_proxied_https(conn) do
    rewrite_url_as_https(conn)
  end

  defp rewrite_url_as_https(conn = %Plug.Conn{query_string: query_string}) do
    https_url_with_path(get_forwarded_host(conn), Plug.Conn.full_path(conn), query_string)
  end

  defp https_url_with_path(host, path, ""), do: "https://#{host}#{path}"
  defp https_url_with_path(host, path, query), do: "https://#{host}#{path}?#{query}"

end