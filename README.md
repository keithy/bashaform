
![YAML FREE ZONE](https://badgen.net/badge/yaml/free/green)

# angelbox/bashaform

The *simplest possible* remote management of infrastucture. 
The license, simplicity and modular form allows these scripts
to be easily adopted into and combined with other projects.

## Installation

```
$> git clone https://github.com/keithy/bashaform.git ~/angelbox/bashaform
```

Prepend to `~/.ssh/config`

```
Include ~/angelbox/*/*/*/*.ssh_config
```

## Example

```console
# Scripts obtain the parameters for a single server
# from the present working directory.

$> cd ~/angelbox/bashaform/example/honey1.demo

# long-form no installation required

$> ~/angelbox/bashaform/oci/action
Actions: ID|NAME|INFO|START|STOP|SOFTSTOP|RESET|SOFTRESET|
         SUSPEND|TERMINATE|EXTERMINATE|STATUS|IP

$> ~/angelbox/bashaform/oci/action status
honey1 RUNNING

# short-form (install as an alias)
$> alias bf=~/angelbox/bashaform/bashaform

# short form (install as an executable)
$> cd ~/bin ; ln -s ~/angelbox/bashaform/bashaform ~/bin/bf ; cd -

# Some scripts operate upon the whole tenancy (of the current server)
$> bf oci/status
+------------+---------+
| Name       | State   |
+------------+---------+
| honey1     | RUNNING |
| nameserver | RUNNING |
+------------+---------+
```

## Folder based configuration

The `box` script prints out the parameters defining the box:
    
    1. the box
    2. the venue
       1. the config (usually default)
       2. the location 
       3. the type

```console
>$ cd ~/angelbox/bashaform/example/honey1.demo`
>$ bf oci/box

[~/angelbox/bashaform/example/honey1.demo/box.env]

# Box

box='honey1.demo'
desc='Honey Pot Server'

# Venue

# oci_config_file='~/.oci/config' # default
# oci_config='DEFAULT'
location='location/london-1.env'
instance='oci_free/amd-micro_rocky.env'

[location/london-1.env]

zone='HllT:UK-LONDON-1-AD-1'
subnet='subnet-default'

[oci_free/amd-micro_rocky.env]

shape='VM.Standard.E2.1.Micro'
spec='Intel.c2.1G.50Gb'
docs='https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm#Compute_Shapes'

# The image match string given references the first match
# obtained from ~/angelbox/bashaform/oci/images

image='Rocky-8-OCP-8.7-20230405.0.x86_64.uefi'

# not listed so... directly provide the ocid of the image we want
image_id='ocid1.image.oc1..aaaaaaaa6ccbrxnbumu3pgej4fkz4hocepobygopdkwfyp5jxeww7ykrf2aq'

[~/.oci/config:DEFAULT]
...
TENANCY=ocid1.tenancy.oc1..aaaaaaaaen5ebfkcxicvfofnjvjd5qc4ib3vrnirtqiddsoip7ztnfnuu2ga
...
```

The `box.env` file is specific but minimal; the venue fields, `location` and `instance`
reference files linked in from a library of potential venues. However values in `box.env` do override defaults provided there.

A box's folder may have several venues linked (though symlinks) available as options to select from.

```console
$> ls -l
box.env
honey.ssh_config
location/london-1.env -> ../../../oci/location/london-1.env
oci_free/amd-micro_rocky.env -> ../../../oci/instance/free/amd-micro_rocky.env
oci_free/amd-micro_ubuntu.env -> ../../../oci/instance/free/amd-micro_ubuntu.env
oci_free/ampere-flex_rocky.2c.12G.50Gb.env -> ../../../oci/instance/free/ampere-flex_rocky.2c.12G.50Gb.env
oci_free/ampere-flex_ubuntu.2c.12G.50Gb.env -> ../../../oci/instance/free/ampere-flex_ubuntu.2c.12G.50Gb.env
```

## Oracle Cloud

OCI is accessed though the `oci-cli` tool, which needs to be installed separately and 
configured for the tenancy, including ssh identity-files for access. 

 Since oci-cli is in iself a python application it is preferable to install it via the nix
 package manager (mac/linux) so that it is fully isolated and independent of other python installations in the OS.

```console
oci setup config  # > ~/.oci/config
```

The default configuration is created in `.oci/config`, but any other file can be specified in `box.env`.

```console
# box.env
oci_config_file='~/.oci/config2'
oci_config='MY_CLOUD'
```

NOTE: The tenancy 'subnet' will need to be renamed to the value expected, 'subnet-default' is the default used in the venue files provided. (this may be overriden on an individual basis in `box.env`) 

## Example - honey pot

The honey-pot server example once provisioned, is configured and managed through the `angelbox/nixbox` project. Here we just handle provisioning.

To show the whole lifecycle we begin by terminating the previous instance.

```console
$ ~/angelbox/bashaform/oci/action
Actions: ID|NAME|INFO|START|STOP|SOFTSTOP|RESET|SOFTRESET|SUSPEND|TERMINATE|STATUS|IP

$ ~/angelbox/bashaform/oci/action exterminate
(exterminate - also terminates boot volume)
Are you sure you want to delete this resource? [y/N]: y
$> ~/angelbox/bashaform/oci/status
+------------+-------------+
| Name       | State       |
+------------+-------------+
| honey1     | TERMINATING |
| nameserver | RUNNING     |
+------------+-------------+
```

Launching a new instance could not be easier.

```console
$ ~/angelbox/bashaform/oci/launch

Instance_name: honey1
Shape: VM.Standard.E2.1.Micro
Zone: HllT:UK-LONDON-1-AD-1
Ssh_pub_key: /Users/keith/.ssh/id_ed25519.pub
Image_id: ocid1.image.oc1.uk-london-1.aaaaaaaa7k76lxeympuejztdks4vtspepqd2jzcxonv35v62vpixvznqvhja
Subnet_id: ocid1.subnet.oc1.uk-london-1.aaaaaaaa7tezd7uokv3ilc5ex2olbd6bw3a5xgs4crtozdvh6y4ntnoypika
Action completed. Waiting until the resource has entered state: ('RUNNING',)

New IP: 143.47.238.158
Updating: honey.ssh_config
Host *honey1.demo*
    User root
    Port 22
    Hostname 143.47.238.158
```

The Ubuntu image provided does not have the root user enabled. For consistency the `user_data/ubuntu/enable_root.bash` script is available as an optional extra to fix this. 

As a result the instance is immediately available. (assuming that `.ssh/config` includes the ssh_config file via `Include ~/angelbox/bashaform/example/*/*.ssh_config`), 

```console
localhost$ ssh honey.demo
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-1029-oracle x86_64)

root@honey1:~# 
```

## Debug/Log levels

Environment variables `QUIET, VERBOSE, DEBUG` control output

## MacOS X / Dependencies

Installed from nixpkgs:

```
nix-env -iA nixpkgs.bashInteractive
nix-env -iA nixpkgs.mktemp
nix-env -iA nixpkgs.coreutils
nix-env -iA nixpkgs.azure-cli
nix-env -iA nixpkgs.aws-cli
nix-env -iA nixpkgs.oci-cli
# nix-env -iA nixpkgs.gnused
```