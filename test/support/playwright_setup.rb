require "open3"
require "shellwords"

module PlaywrightTestSetup
  module_function

  def verify!
    stdout, stderr, status = Open3.capture3(*cli_args, "install", "--list")

    return if status.success? && chromium_installed?(stdout)

    raise <<~ERROR
      Playwright is not ready for system tests.

      #{failure_message(stdout, stderr, status)}

      Install the required browser with:
        #{install_command}
    ERROR
  end

  def cli_args
    Shellwords.split(cli_command)
  end

  def cli_command
    ENV.fetch("PLAYWRIGHT_CLI_EXECUTABLE_PATH") do
      "npx --yes playwright@#{Playwright::COMPATIBLE_PLAYWRIGHT_VERSION}"
    end
  end

  def install_command
    "#{cli_command} install chromium"
  end

  def chromium_installed?(output)
    output.include?("chromium-") && output.include?("chromium_headless_shell-")
  end

  def failure_message(stdout, stderr, status)
    return "The Playwright CLI is available, but Chromium is not installed." if status.success?

    details = [stdout, stderr].reject(&:empty?).join("\n").strip
    "The Playwright CLI could not be run (exit status #{status.exitstatus}).\n#{details}"
  end
end
