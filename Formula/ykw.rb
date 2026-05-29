class Ykw < Formula
  desc "Multi-recipient YubiKey OpenPGP workflow CLI (Bash)"
  homepage "https://github.com/j4y-w4lk3r/ykw"
  url "https://github.com/j4y-w4lk3r/ykw/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "d8b5a75a1c2ca041f6614533d077f02cc248dfbc2f38ba3538a1bea6722a6883"
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

    # README only — pubkeys + secret.txt are no longer bundled. Phase 5
    # ships `ykw bootstrap` which materializes both from the encrypted bu
    # bundle in B2, so packaging stale pubkeys with the formula is dead
    # weight (and goes stale immediately whenever a YubiKey is rotated).
    pkgshare.install "README.md"

    # `bin/ykw` is a one-line wrapper. lib.sh decides where the workspace
    # lives: $YKW_WORKSPACE if set, dev-checkout if .git is present beside
    # lib.sh, otherwise $XDG_DATA_HOME/ykw (default ~/.local/share/ykw).
    # Users run `ykw bootstrap` once after install to populate it.
    (bin/"ykw").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/ykw" "$@"
    EOS
    chmod 0755, bin/"ykw"
  end

  test do
    # `ykw --help` reads its own header comment block, so we know:
    #   1. the symlink resolves
    #   2. lib.sh / op.sh are sourceable (the script aborts during source if not)
    #   3. the version banner is printed
    assert_match "ykw", shell_output("#{bin}/ykw --help 2>&1")
  end
end
