
![YAML FREE ZONE](https://badgen.net/badge/yaml/free/green)

# angelbox/bashaform

These scripts aim to provide the simplest possible remote management
of infrastucture. Their license, minimalist and modular form allows 
them to be easily adopted into and combined with other projects. 

* angelbox/angel a command line interface integrating this and other projects

## Folder based configuration

Each cloud resource managed has a folder and scripts find their 
parameters from the current working directory.

```console
>$ cd ~/code/bashaform/example/honey1.demo`
>$ ~/code/bashaform/oci/box

# ~/code/bashaform/example/honey1.demo/box.env
box='honey1.demo'
desc='Honey Pot Server'

# Venue
type='oci-micro-ubuntu'
location='oci-london-1'
#location='aws-london'

# ~/code/bashaform/example/honey1.demo/oci-london-1.env
zone='HllT:UK-LONDON-1-AD-1'
subnet='subnet-default'

# ~/code/bashaform/example/honey1.demo/oci-micro-ubuntu.env
shape='VM.Standard.E2.1.Micro'
spec='Intel.c2.1G.50Gb'
docs='https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm#Compute_Shapes'
image='Canonical-Ubuntu-22.04-Minimal-20'
user_data='enable_root.sh'
```

The `box.env` file is specific but minimal; the venue fields, `location` and `type`
reference files linked in from a library of potential venues. Values in `box.env`
do override defaults provided there.

A boxes folder may have several venues linked (though a symlink) to be available as options to select from. 

```console
$> ls -l
box.env
honey.ssh_config
venues/oci/flex_ubuntu.env
venues/oci/micro_ubuntu.env
venues/oci/flex-go-large_ubuntu.env
venues/oci/london-1.env
oci-london-1.env -> ../../venues/oci/locs/london-1.env
oci-micro-ubuntu.env -> ../../venues/oci/intances/free/micro_ubuntu.env
```

## Oracle Cloud

OCI is accessed though the `oci-cli` tool, which needs to be installed separately and 
configured for the tenancy, including ssh identity-files for access. 

 Since oci-cli is in iself a python application it is preferable to install it via the nix
 package manager (mac/linux) so that it is fully isolated and independent of other python installations in the OS.

```console
oci setup config  # > ~/.oci/config
```

The default configuration is created in `.oci/config`, but any other environment can be used via:

```console
~/code/bashaform/oci/use ~/.oci/my-config
```

NOTE: The tenancy 'subnet' will need to be renamed to the value expected, 'subnet-default' is the default used in the venue files provided. (this may be overriden on an individual basis in box.env) 

## Example - honey pot

The honey-pot server once provisioned, is configured and managed through the `angelbox/nixbox` project. Here we just handle provisioning.

To show the whole lifecycle we begin by terminating the previous instance.

```console
$ ~/code/bashaform/oci/action
Actions: ID|NAME|INFO|START|STOP|SOFTSTOP|RESET|SOFTRESET|SUSPEND|TERMINATE|STATUS|IP

$ ~/code/bashaform/oci/action exterminate
(exterminate - also terminates boot volume)
Are you sure you want to delete this resource? [y/N]: y
$> ~/code/bashaform/oci/status
+------------+-------------+
| Name       | State       |
+------------+-------------+
| honey1     | TERMINATING |
| nameserver | RUNNING     |
+------------+-------------+
```

Launching a new instance could not be easier.

```console
$ ~/code/bashaform/oci/launch

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

The Ubuntu image provided does not have the root user enabled. For consistency the `enable_root.sh` user_data script is available as an optional extra to fix this. 

As a result the instance is immediately available. (assuming that `.ssh/config` includes the ssh_config file via `Include ~/code/bashaform/example/*/*.ssh_config`), 

```console
localhost$ ssh honey.demo
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-1029-oracle x86_64)

root@honey1:~# 
```

## Debug/Log levels

Environment variables `QUIET, VERBOSE, DEBUG` control output

## Install anything - self-extracting archive packages

A simple mechanism for installing an overlay of files onto the new system will be provided via, `makeself` the self-extracting archive utility.
