# SSH host key verification

`StrictHostKeyChecking yes` requires a verified host key in
`~/.ssh/known_hosts` before a connection is allowed. This prevents a first-use
prompt from turning an unverified key into a permanent trust decision.

Private infrastructure keys are stored in the ignored `~/.ssh/known_hosts`.
Public trust anchors for GitHub and Codeberg are stored in the tracked
`~/.ssh/known_hosts.services`, which their SSH stanza selects explicitly.

## Verify a host key

Use a source that does not depend on the SSH connection being verified:

- For a hosted service, compare against fingerprints published on its official
  HTTPS documentation.
- For a server you administer, open its provider or hypervisor console and run:

  ```sh
  ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
  ```

- For a machine with local console access, run the same command directly on
  that machine.
- For an organization-managed host, obtain the fingerprint from the trusted
  provisioning system or an administrator over an authenticated channel.

Do not treat `ssh-keyscan` output as verification. It retrieves the key without
authenticating the server and can therefore retrieve an attacker's key. It is
useful only for obtaining a candidate key to compare with a trusted fingerprint.

## Enroll a host

Fetch a candidate ED25519 key into a temporary file:

```sh
host=example.com
keyfile=$(mktemp)
ssh-keyscan -T 10 -t ed25519 "$host" > "$keyfile"
ssh-keygen -lf "$keyfile"
```

Compare the displayed SHA256 fingerprint with the trusted source. If and only
if they match, append the candidate key and remove the temporary file:

```sh
cat "$keyfile" >> ~/.ssh/known_hosts
rm "$keyfile"
chmod 600 ~/.ssh/known_hosts
```

For a public service whose official key should be tracked, append it to
`~/.ssh/known_hosts.services` instead and explicitly select that file in the
service's SSH stanza with `UserKnownHostsFile`.

Confirm that OpenSSH can find the enrolled key:

```sh
ssh-keygen -F "$host" -f ~/.ssh/known_hosts
```

## Replace a changed key

Do not remove or replace a changed key until the new fingerprint has been
verified out of band. After verification:

```sh
host=example.com
ssh-keygen -R "$host" -f ~/.ssh/known_hosts
```

Then enroll the new key using the process above.

## Published service fingerprints

- GitHub: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
- Codeberg: https://docs.codeberg.org/security/ssh-fingerprint/

For the Hetzner host, verify the candidate fingerprint from the Hetzner console
before enrollment. The currently observed, unverified ED25519 candidate is:

```text
SHA256:wQRodpBKqUnBbms035Z7HtSqmIB8xyJNggKSA/SwIP4
```

## Personal and agent credentials

Personal macOS and Linux sessions use the existing YubiKey-backed agent and
OpenPGP Git signing. The tracked `~/.ssh/id_rsa` contains **public** key material,
despite its name: OpenSSH can use an `IdentityFile` public key to select the
matching private key held by an agent. Its filename stays unchanged for existing
Stow links and private host fragments.

In `MACHINE_IDENTITY=agent` context, GitHub, Codeberg, and `192.168.10.*`
select `~/.ssh/agent_ed25519.pub` through the dedicated agent instead. The Coder
bootstrap identity is excluded in that context. Other destinations retain
default-deny or their explicit private host policy; authorize/configure additional
destinations individually. Multiple IdentityFile entries are additive, so the
two identities deliberately live in mutually exclusive Match blocks.

### Native agent lifetime

Home Manager installs a separate native service, without replacing the personal
session's SSH_AUTH_SOCK:

- Linux: user `ssh-agent.service`, socket
  `${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/dotfiles-agent`.
- macOS: launchd `org.nix-community.home.ssh-agent`, socket
  `$(getconf DARWIN_USER_TEMP_DIR)/dotfiles-agent`.

Apply dotfiles through Home Manager normally. For the current Stow-managed Mac,
service installation waits for the separately planned Home Manager migration;
these scripts do not start an ad-hoc fallback agent.

On Linux, a working systemd user manager is required. Check whether it survives
disconnects:

```sh
loginctl show-user "$(id -un)" -p Linger --value
```

If necessary, explicitly enable it as an operator:

```sh
sudo loginctl enable-linger "$(id -un)"
```

Keys have no configured expiry or per-use confirmation. Removing a key, stopping
or restarting the agent, rebooting, or logging out when the user manager does not
linger clears loaded use. An unchanged `dot switch` does not deliberately restart
the agent; a service/package update may, requiring another unlock.

### Provision the encrypted key

Do this yourself on a trusted personal machine; never put the passphrase in
coding-agent context, shell arguments/history, Nix, Git, or Coder parameters.

1. Confirm `~/.ssh/agent_ed25519` and its public companion do not already exist
   (including symlinks). Never overwrite an existing identity. For a new key:

   ```sh
   ssh-keygen -t ed25519 -a 100 -f ~/.ssh/agent_ed25519 -C nick-agent
   ```

   Enter a strong, nonempty passphrase at the terminal prompt. Keep a recoverable
   copy of the complete **encrypted OpenSSH file**, with all line breaks, in
   your password manager. A restore must return that original encrypted file,
   not a decrypted export. Choose the password manager's storage feature yourself.

2. Verify the remote host key using the process above and establish an authorized
   bootstrap connection (personal key or existing Coder access). In these examples,
   replace `remote-box` with your existing trusted destination:

   ```sh
   ssh remote-box 'umask 077; mkdir -p ~/.ssh; chmod 700 ~/.ssh'
   ```

   Confirm neither remote key file exists. If either exists, compare public
   fingerprints: retain an identical identity, and stop on a mismatch instead of
   overwriting. Do not install whole-vault credentials or sign into your entire
   password-manager vault on the remote.

3. For absent target files, ensure the local private file is mode 0600 **before**
   transferring it, so `scp -p` preserves safe permissions:

   ```sh
   chmod 600 ~/.ssh/agent_ed25519
   chmod 644 ~/.ssh/agent_ed25519.pub
   scp -p ~/.ssh/agent_ed25519 ~/.ssh/agent_ed25519.pub remote-box:.ssh/
   ssh remote-box 'chmod 600 ~/.ssh/agent_ed25519; chmod 644 ~/.ssh/agent_ed25519.pub'
   ssh-keygen -lf ~/.ssh/agent_ed25519.pub
   ssh remote-box 'ssh-keygen -lf ~/.ssh/agent_ed25519.pub'
   ```

   Compare the public fingerprints. Only the already-encrypted private file and
   public companion cross the connection; enter the passphrase separately when
   unlocking on the box. The unlock and `ssh-add -T` below also prove the loaded
   private key matches the intended public key.

4. Register only the `.pub` key for intended repository authentication and SSH
   Git signing. Use restricted accounts or repository-scoped deploy keys where
   appropriate: adding an SSH key to a personal GitHub account gives it that
   account's repository access, not a narrower scope by itself. This is normally
   an outbound client key; do not add it to a box's `authorized_keys` unless
   inbound access is separately intended.

The same restored key on multiple machines shares authorization and revocation
fate. If a rebuilt workspace loses its home storage, restore the encrypted key,
public companion, and verification trust file. Home Manager recreates the machine
identity selector automatically; no repeated switch is needed to fight Coder's
Git config writes.

### Unlock, sign, and verify

Once the native service is running, a fresh remote shell with
`MACHINE_IDENTITY=agent` already selects its socket. Unlock at a human terminal:

```sh
ssh-add ~/.ssh/agent_ed25519
ssh-add -l
ssh-add -T ~/.ssh/agent_ed25519.pub
```

From a personal terminal, explicitly select the dedicated agent instead:

```sh
with-agent ssh-add ~/.ssh/agent_ed25519
```

Use `with-agent` for the inspection commands there too. The service has no
default key expiry; optional `-t 0` makes unlimited lifetime explicit but is not
required.

Do not add `-c` (per-use confirmation). Subsequent Git signing and allowed SSH
operations use the loaded key without another passphrase prompt until its agent
lifetime ends. The clients select the public file, not the encrypted private file.

For local Git verification, explicitly create
`~/.ssh/agent_ed25519.allowed_signers` from the restored public key. Its line is:

```text
vandyck.nick@outlook.com namespaces="git" ssh-ed25519 <base64-public-key>
```

Replace the key fields with the actual `.pub` contents. Inspect and retain a
different existing trust file rather than silently overwriting it. This file is
needed for the configured verification policy, not for creating signatures.
All `~/.ssh/agent_ed25519*` files are excluded from this repository.

After registering the key, exercise an authorized private repository and a signed
commit from inside each coding tool. Verify with `git verify-commit HEAD` in that
agent context and confirm a subsequent operation needs no new prompt. Do not use
an unrelated production repository as a smoke test.

Remove the loaded identity with:

```sh
with-agent ssh-add -d ~/.ssh/agent_ed25519.pub
```

This does not revoke provider/server permissions or terminate already-authenticated
connections. Revoke the registered public key separately if needed.

This setup is routing, not isolation: same-user coding processes can read the
encrypted private file and may access other agent sockets. The passphrase and
limited server-side authorization remain important. Native service persistence
across reconnects/restarts must be checked on the deployed machine; an isolated
agent signing check does not verify systemd or launchd deployment.
