defmodule Mupex do
  import Plug.Conn

  def config, do: Application.get_env(:mupex, Mupex)
  def config(key), do: Application.get_env(:mupex, Mupex)[key]

  def next_headers(conn, opts \\ []) do
    opts = Keyword.merge(config(:headers), opts)
    parse_headers(read_part_headers(conn, opts))
  end

  def next_body(conn, opts \\ []) do
    opts =
      Keyword.merge(config(), opts)
      |> Keyword.delete(:headers)

    start_fun = fn -> {read_part_body(conn, opts), opts} end
    next_fun = &stream_body/1
    after_fun = fn _x -> nil end

    Stream.resource(start_fun, next_fun, after_fun)
  end

  defp stream_body({{:more, tail, conn}, opts}) do
    {[{:data, tail, conn}], {read_part_body(conn, opts), opts}}
  end

  defp stream_body({{:ok, tail, conn}, opts}) do
    {[{:data, tail, conn}], {{:done, conn}, opts}}
  end

  defp stream_body({{:done, conn}, opts}) do
    {[{:done, conn}], {{:halt, conn}, opts}}
  end

  defp stream_body({{:halt, _conn}, _opts}), do: {:halt, nil}

  defp parse_headers({:ok, mp_headers, conn}) do
    {name, params, content_type} = multipart_type(mp_headers)
    {:ok, name, params, content_type, conn}
  end

  defp parse_headers({:done, conn}) do
    {:done, conn}
  end

  defp multipart_type(mp_headers) do
    with {_, disposition} <- List.keyfind(mp_headers, "content-disposition", 0),
         [_, params] <- :binary.split(disposition, ";"),
         %{"name" => name} = params <- Plug.Conn.Utils.params(params) do
      handle_disposition(params, name, mp_headers)
    else
      _ -> :skip
    end
  end

  defp handle_disposition(params, name, mp_headers) do
    {name, Map.delete(params, "name"), get_header(mp_headers, "content-type")}
  end

  defp get_header(headers, key) do
    case List.keyfind(headers, key, 0) do
      {^key, value} -> value
      nil -> nil
    end
  end
end
