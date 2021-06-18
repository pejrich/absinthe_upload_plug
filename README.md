# AbsintheUploadPlug

This is used to convert file uploads to the Absinthe format from the "map"/"operations" format used by a lot of web/mobile clients.

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
