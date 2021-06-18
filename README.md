# AbsintheUploadPlug

This is used to convert file uploads to the Absinthe format from the `"map"`/`"operations"` format used by a lot of web/mobile clients.

```
%{
  "0" => %{
    content_type: "image/png",
    filename: "test.png",
    path: "/tmp/plug-1605/multipart-1605259564-0"
  },
  "map" => "{\"0\":[\"variables.attachment\"]}",
  "operations" =>
    "{\"query\":\"mutation ImageUpload($attachment: Upload) {\\n  imageUpload(attachment: $attachment)\\n}\",\"variables\":{\"attachment\":null},\"operationName\":\"ImageUpload\"}"
}
```

to this:

```
"0" => %{
  content_type: "image/png",
  filename: "test.png",
  path: "/tmp/plug-1605/multipart-1605259564-0"
},
"query" => "mutation ImageUpload($attachment: Upload) {  imageUpload(attachment: $attachment)}",
"variables" => %{"attachment" => "0"}
```

Inspired by this: `https://github.com/shavit/absinthe-upload`

But that lib didn't works for nested params `{variables: {input: {upload: ...}}}`, or lists of uploads `{variables: {uploads: [...]}}`

This should handle both use cases.

## Installation

```elixir
def deps do
  [
    {:absinthe_upload_plug, git: "https://github.com/pejrich/absinthe_upload_plug.git"}
  ]
end
```
## Usage

You can add the plug anywhere before `Absinthe.Plug`, I typically add it here:

```
pipeline :graphql do
  plug(AbsintheUploadPlug)
  ...
end
```
