config =
  case :os.type() do
    {_, :darwin} -> [exclude: [macos: false]]
    _ -> []
  end

ExUnit.configure(config)
ExUnit.start()
