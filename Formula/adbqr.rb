# Homebrew formula for adbqr, distributed via a tap:
#   brew install kristjan/tap/adbqr
#
# Release steps (set the version and sha256):
#   1. git tag v0.1.0 && git push --tags
#   2. Compute the tarball sha256:
#        curl -sL https://github.com/kristjan/adbqr/archive/refs/tags/v0.1.0.tar.gz | shasum -a 256
#   3. Paste it into `sha256` below and bump `url`/`version`.
class Adbqr < Formula
  desc "Pair a laptop to an Android phone over wireless debugging with a QR code"
  homepage "https://github.com/kristjan/adbqr"
  url "https://github.com/kristjan/adbqr/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_TARBALL_SHA256"
  license "MIT"

  depends_on "qrencode"

  # adb ships in Android platform-tools: a cask on macOS, a formula on Linux.
  on_linux do
    depends_on "android-platform-tools" => :recommended
  end

  def install
    bin.install "bin/adbqr"
  end

  def caveats
    <<~EOS
      adbqr needs the Android `adb` tool on your PATH:
        macOS:  brew install --cask android-platform-tools
        Linux:  installed automatically if available, else use your distro's
                android-tools / platform-tools package.
    EOS
  end

  test do
    assert_match "Usage: adbqr", shell_output("#{bin}/adbqr --help")
  end
end
