import Config

config :mix_test_watch,
  extra_extensions: [".zig"],
  tasks: [
    "test",
    "credo --strict --all",
    "docs"
  ]
