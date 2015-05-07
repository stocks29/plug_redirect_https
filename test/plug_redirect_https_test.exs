defmodule PlugRedirectHttpsTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @default_opts []

  @host "foo.com"
  @path "/foo?bar=10"

  test "redirected to https when forwarded proto is http" do
    conn = %Plug.Conn{status: status} = conn(:get, @path, nil) 
    |> put_req_header("x-forwarded-proto", "http")
    |> put_req_header("host", @host)
    |> Plug.Conn.fetch_query_params
    |> PlugRedirectHttps.call(@default_opts)

    assert status == 302
    assert Plug.Conn.get_resp_header(conn, "location") == ["https://#{@host}#{@path}"]
  end

  test "request passes through when no forwarded proto" do
    %Plug.Conn{state: state} = conn(:get, @path)
    |> Plug.Conn.fetch_query_params
    |> PlugRedirectHttps.call(@default_opts)

    assert state == :unset
  end

  test "request passes through when forwarded proto already https" do
    %Plug.Conn{state: state} = conn(:get, @path, nil)
    |> put_req_header("x-forwarded-proto", "https")
    |> put_req_header("host", @host)
    |> Plug.Conn.fetch_query_params
    |> PlugRedirectHttps.call(@default_opts)

    assert state == :unset
  end

  test "request passes through when forwarded proto not http or https" do
    %Plug.Conn{state: state} = conn(:get, @path, nil)
    |> put_req_header("x-forwarded-proto", "foo")
    |> put_req_header("host", @host)
    |> Plug.Conn.fetch_query_params
    |> PlugRedirectHttps.call(@default_opts)

    assert state == :unset
  end

end
