## OPNsense unbound adblock

Action and script to add & update adblock lists with a cron job in GUI.

The file `./additional_zones.txt` can be used to add additional domains.

The file `./whitelist.txt` can be used to whitelist domains.

(Just place a domain per line, awk takes care of the rest).

## Usage

### `actions_update-hosts.conf`

Must be placed in `/usr/local/opnsense/service/conf/actions.d/`

Execute `$ service configd restart` afterwards.

### `update-hosts.sh`

Must be placed in `/usr/home/update-hosts.sh` (or change the path in `actions_update-hosts.conf`).