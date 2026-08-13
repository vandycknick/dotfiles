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
