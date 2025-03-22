# fireblock - _Firefox Website Blocker for Linux_

## Overview

This script allows users to block or whitelist specific URLs or paths in Firefox by modifying the `policies.json` file. Unlike traditional website blockers, it does not block entire domains by default, giving users fine-grained control over what is restricted.

## Features

- Block specific URLs or paths in Firefox
- Add exceptions (whitelist URLs or paths)
- Prevent duplicate entries
- Works on a per-user basis (`/usr/lib/firefox/distribution/policies.json`)
- Can be adapted for system-wide policies

## Prerequisites

This script requires `jq`, a lightweight JSON processor. Install it with:

```sh
sudo apt install jq  # Debian/Ubuntu
sudo dnf install jq  # Fedora
brew install jq      # macOS
```

## Installation

1. Save the script as `fireblock` in `/usr/local/bin/`:
      ```sh
      sudo cp fireblock.sh /usr/local/bin/fireblock
      sudo chmod +x /usr/local/bin/fireblock
      ```
2. Ensure `/usr/local/bin/` is in your `$PATH` (it usually is by default):
      ```sh
      export PATH="/usr/local/bin:$PATH"
      ```

## Usage

### Block Specific URLs or Paths

To block specific pages or paths on a website, run:

```sh
fireblock example.com another-site.com/specific-page
```

This adds only the specified URLs or paths to Firefox's blocked list.

### Blocking Sub-paths or Entire Domains

If you want to block all sub-paths or an entire domain, add the `*` character at the end:

```sh
fireblock example.com/* another.com/pages/*
```

This ensures all pages under `example.com` are blocked and all sub-pages in `another.com/pages` are blocked.

### Add Exceptions (Whitelist)

To allow specific sites or paths while others are blocked, use the `-e` flag:

```sh
fireblock -e example.com/specific-page
```

This adds `example.com/specific-page` to the exceptions list.

## Editing Policies Manually

The policy file is located at:

```sh
/usr/lib/firefox/distribution/policies.json
```

For system-wide policies (root access required):

```sh
/etc/firefox/policies/policies.json
```

## Notes

- **Restart Firefox for changes to take effect.**
- The script ensures no duplicate entries are added.
- For enterprise or system-wide settings, update the `POLICY_FILE` variable in the script accordingly.

## References

- [Customizing Firefox using policies.json](https://support.mozilla.org/en-US/kb/customizing-firefox-using-policiesjson)
- [Mozilla Policy Templates - Documentation ](https://mozilla.github.io/policy-templates)
