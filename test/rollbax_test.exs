defmodule RollbaxTest do
  use ExUnit.RollbaxCase

  setup_all do
    {:ok, _} = start_rollbax_client("token1", "test")
    :ok
  end

  setup do
    {:ok, _} = RollbarAPI.start(self())
    on_exit(fn -> RollbarAPI.stop() end)
  end

  test "exception report" do
    stacktrace = [{Test, :report, 2, [file: 'file.exs', line: 16]}]
    exception = RuntimeError.exception("pass")
    :ok = Rollbax.report(exception, stacktrace)
    assert_receive {:api_request, body}
    assert body =~ "body\":\"** (RuntimeError) pass\\n    file.exs:16: Test.report/2\\n"
  end
end
