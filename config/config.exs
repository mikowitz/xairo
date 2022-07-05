import Config

config :mix_test_watch,
  extra_extensions: [".rs"],
  tasks: [
    "test --exclude ci_only",
    "format",
    "credo --strict --all",
    "docs"
  ]
