+++
title = "GPG Key Transition Statement (26/03/15)"
date = 2026-03-15
# updated =
description = "Transition Statement Regarding GPG Public Key Update"
[taxonomies]
categories = ["Announcement"]
tags = ["security"]
[extra]
lang = "en"
toc = false
math = true
mermaid = true
+++

I have transitioned my GPG primary key to a new one.

## Key Information

| | Old Key | New Key |
|---|---|---|
| **Fingerprint** | `ABB3 904C 7263 155D 9F5C 34A3 198F 1B4D 8D77 678F` | `9700 B737 B525 70D7 B783 94E5 2DF1 A76B 8DC2 D6E3` |
| **Algorithm** | Ed25519 | Ed25519 |
| **Status** | Revoked | Active (subkeys valid until 2027-03-15) |

## Reason for Transition

Reviewed the management of the old key and switched to a more secure setup using a YubiKey.

## Transition Statement

A transition statement signed with the new key is published on GitHub Gist.

- Transition Statement: 
  - [Gist](https://gist.github.com/m1sk9/e61698b4e4980e7f7f247401125f8d26)
  - [File](./transition-statement.txt.asc)
- [keys.openpgp.org](https://keys.openpgp.org/search?q=me%40m1sk9.dev)

> The old secret key is no longer in my possession, so there is no signature from the old key.
> My identity can be verified via the keys.openpgp.org listing above and
> the Verified commit history on GitHub.

## Action Required

- If you send me encrypted email: please switch to the new key.
- If you verify my signatures: please re-import the new key.

```bash
gpg --keyserver keys.openpgp.org \
    --recv-keys 9700B737B52570D7B78394E52DF1A76B8DC2D6E3
```
