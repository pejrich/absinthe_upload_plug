defmodule AbsintheUploadPlugTest do
  use ExUnit.Case
  doctest AbsintheUploadPlug

  test "init/1 pass the conn" do
    assert AbsintheUploadPlug.init(%{}) == %{}
  end

  test "conn/2 works with single param at the base" do
    params_ = %{
      "0" => %{
        content_type: "image/png",
        filename: "test.png",
        path: "/tmp/plug-1605/multipart-1605259564-0"
      },
      "map" => "{\"0\":[\"variables.attachment\"]}",
      "operations" =>
        "{\"query\":\"mutation ImageUpload($attachment: Upload) {\\n  imageUpload(attachment: $attachment)\\n}\",\"variables\":{\"attachment\":null},\"operationName\":\"ImageUpload\"}"
    }

    opts = []

    conn = AbsintheUploadPlug.call(%{body_params: params_, params: params_}, opts)
    assert %{params: params} = conn

    assert params["query"] ==
             "mutation ImageUpload($attachment: Upload) {  imageUpload(attachment: $attachment)}"

    assert params["0"] == %{
             content_type: "image/png",
             filename: "test.png",
             path: "/tmp/plug-1605/multipart-1605259564-0"
           }

    assert params["variables"] == %{
             "attachment" => "0"
           }

    assert Map.get(conn, "map") == nil
    assert Map.get(conn, "operations") == nil
  end

  test "conn/2 works with nested params" do
    params_ = %{
      "0" => %{
        content_type: "image/png",
        filename: "test.png",
        path: "/tmp/plug-1605/multipart-1605259564-0"
      },
      "map" => "{\"0\":[\"variables.input.attachment\"]}",
      "operations" =>
        "{\"query\":\"mutation ImageUpload($input: ImageUploadInput!) {\\n  imageUpload(input: $input)\\n}\",\"variables\":{\"input\":{\"attachment\":null}},\"operationName\":\"ImageUpload\"}"
    }

    opts = []

    conn = AbsintheUploadPlug.call(%{body_params: params_, params: params_}, opts)
    assert %{params: params} = conn

    assert params["query"] ==
             "mutation ImageUpload($input: ImageUploadInput!) {  imageUpload(input: $input)}"

    assert params["0"] == %{
             content_type: "image/png",
             filename: "test.png",
             path: "/tmp/plug-1605/multipart-1605259564-0"
           }

    assert params["variables"] == %{
             "input" => %{
               "attachment" => "0"
             }
           }

    assert Map.get(conn, "map") == nil
    assert Map.get(conn, "operations") == nil
  end

  test "conn/2 works with list of inputs in nested params" do
    params_ = %{
      "0" => %{
        content_type: "image/png",
        filename: "test.png",
        path: "/tmp/plug-1605/multipart-1605259564-0"
      },
      "1" => %{
        content_type: "image/png",
        filename: "test2.png",
        path: "/tmp/plug-1605/multipart-0123456789-1"
      },
      "map" =>
        "{\"0\":[\"variables.input.attachment.0\"], \"1\": [\"variables.input.attachment.1\"]}",
      "operations" =>
        "{\"query\":\"mutation ImageUpload($input: ImageUploadInput!) {\\n  imageUpload(input: $input)\\n}\",\"variables\":{\"input\":{\"attachment\":[null, null]}},\"operationName\":\"ImageUpload\"}"
    }

    opts = []

    conn = AbsintheUploadPlug.call(%{body_params: params_, params: params_}, opts)
    assert %{params: params} = conn

    assert params["query"] ==
             "mutation ImageUpload($input: ImageUploadInput!) {  imageUpload(input: $input)}"

    assert params["0"] == %{
             content_type: "image/png",
             filename: "test.png",
             path: "/tmp/plug-1605/multipart-1605259564-0"
           }

    assert params["1"] == %{
             content_type: "image/png",
             filename: "test2.png",
             path: "/tmp/plug-1605/multipart-0123456789-1"
           }

    assert params["variables"] == %{
             "input" => %{
               "attachment" => ["1", "0"]
             }
           }

    assert Map.get(conn, "map") == nil
    assert Map.get(conn, "operations") == nil
  end

  test "conn/2 ignore parse errors" do
    assert %{params: %{}} == AbsintheUploadPlug.call(%{params: %{}}, [])
    assert %{body_params: %{}} == AbsintheUploadPlug.call(%{body_params: %{}}, [])

    assert %{:body_params => nil, "operations" => nil} ==
             AbsintheUploadPlug.call(%{:body_params => nil, "operations" => nil}, [])
  end
end
