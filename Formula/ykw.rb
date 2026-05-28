class Ykw < Formula
  desc "Multi-recipient YubiKey OpenPGP workflow CLI (Bash)"
  homepage "https://github.com/j4y-w4lk3r/ykw"
  url "https://github.com/j4y-w4lk3r/ykw/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_RELEASE_TARBALL_SHA256"
  license "MIT"
  head "https://github.com/j4y-w4lk3r/ykw.git", branch: "main"

  depends_on "gnupg"
  depends_on "jq"
  depends_on "ykman"

  # Optional but recommended:
  #   - `op` (1Password CLI): brew install --cask 1password-cli
  #   - `fzf`:                brew install fzf
  # ykw degrades gracefully when these are absent.

  def install
    # Install the bash script + helper libraries side-by-side under libexec/
    # so `ykw` can `source` `lib.sh` and `op.sh` after symlink resolution.
    libexec.install "ykw", "lib.sh", "op.sh"
    chmod 0755, libexec/"ykw"

    # `bin/ykw` is a symlink to `libexec/ykw/ykw`. The script walks the
    # symlink chain at runtime and discovers SCRIPT_DIR=libexec/ykw, which
    # is where the helpers live.
    bin.install_symlink libexec/"ykw"

    # Reference material (READMEs, exported pubkeys, encrypted secret demo).
    pkgshare.install "README.md"
    (pkgshare/"pubkeys").install Dir["pubkeys/*"] if Dir.exist?("pubkeys")
  end

  test do
    # `ykw --help` reads its own header comment block, so we know:
    #   1. the symlink resolves
    #   2. lib.sh / op.sh are sourceable (the script aborts during source if not)
    #   3. the version banner is printed
    assert_match "ykw", shell_output("#{bin}/ykw --help 2>&1")
  end
end
