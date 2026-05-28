class Ykw < Formula
  desc "Multi-recipient YubiKey OpenPGP workflow CLI (Bash)"
  homepage "https://github.com/j4y-w4lk3r/ykw"
  url "https://github.com/j4y-w4lk3r/ykw/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "9b4e2bf8f8a619093a17bbae8e185ffcd4c6b4634d1488fc2777e2e9600aa60a"
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

    # Reference material (READMEs, exported pubkeys, encrypted secret demo).
    pkgshare.install "README.md"
    (pkgshare/"pubkeys").install Dir["pubkeys/*"] if Dir.exist?("pubkeys")

    # `bin/ykw` is a thin shim that points YKW_WORKSPACE at pkgshare/ so the
    # script finds pubkeys/keys.tsv (a symlink wouldn't carry that env var).
    # Users override with their own YKW_WORKSPACE for a writable workspace.
    (bin/"ykw").write <<~EOS
      #!/bin/bash
      export YKW_WORKSPACE="${YKW_WORKSPACE:-#{pkgshare}}"
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
