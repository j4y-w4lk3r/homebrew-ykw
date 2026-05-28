# homebrew-ykw

Homebrew tap for [`ykw`](https://github.com/j4y-w4lk3r/ykw) — the
multi-recipient YubiKey OpenPGP workflow CLI.

## Install

```bash
brew install j4y-w4lk3r/ykw/ykw
```

(or, explicitly: `brew tap j4y-w4lk3r/ykw && brew install ykw`.)

## Formula source of truth

`Formula/ykw.rb` is auto-updated by the release workflow in
[`j4y-w4lk3r/ykw`](https://github.com/j4y-w4lk3r/ykw) on every `vX.Y.Z` tag
push. The canonical formula template lives in that repo at
`Formula/ykw.rb`; this tap is a downstream mirror.

If you need to hand-edit the formula, open a PR against
[`j4y-w4lk3r/ykw`](https://github.com/j4y-w4lk3r/ykw) — pushing to this tap
directly will be overwritten on the next release.
