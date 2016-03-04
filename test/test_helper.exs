ExUnit.start

Mix.Task.run "ecto.create", ~w(-r HookProxy.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r HookProxy.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(HookProxy.Repo)

