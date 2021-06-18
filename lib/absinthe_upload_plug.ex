defmodule AbsintheUploadPlug do
  def init(conn), do: conn

  def call(%{body_params: %{"map" => mvars, "operations" => ops}} = conn, _) do
    with {:ok, map_json} <- Jason.decode(mvars),
         {:ok, ops_json} <- Jason.decode(ops) do
      query = ops_json |> Map.get("query") |> String.replace("\n", "")
      variables = ops_json |> Map.get("variables") |> update_variables(map_json)
      drop_keys = ["operations", "map"]

      conn
      |> Map.update!(:params, fn x ->
        x
        |> Map.put("query", query)
        |> Map.put("variables", variables)
        |> Map.drop(drop_keys)
      end)
    else
      _ -> conn
    end
  end

  def call(conn, _), do: conn

  def update_variables(vars, map_vars) do
    Enum.reduce(map_vars, vars, fn {file_name, [var_path]}, acc ->
      new_var_path =
        var_path
        |> String.trim_leading("variables.")
        |> String.split(".")

      case List.last(new_var_path) |> Integer.parse() do
        {_, ""} ->
          update_in(acc, Enum.drop(new_var_path, -1), fn
            [nil | _] -> [file_name]
            list when is_list(list) -> list ++ [file_name]
            _ -> []
          end)

        _ ->
          put_in(acc, new_var_path, file_name)
      end
    end)
  end
end
