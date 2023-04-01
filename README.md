
![YAML FREE ZONE](https://badgen.net/badge/yaml/free/green)

# angelbox/bashaform

These scripts aim to provide the simplest possible remote management
of infrastucture in a way that can be easily adopted
into other projects.

## Folder based configuration

Each cloud resource managed has a folder and scripts find their 
parameters from the current working directory.

```
$> cd ~/code/bashaform/example/honey1.demo
$> ~/code/bashaform/oci/box

# ~/code/bashaform/example/honey1.demo/box.env
box='honey1.demo'
desc='Honey Pot Server'
venue='oci-london'
#venue='aws-london'

# ~/code/bashaform/example/honey1.demo/oci-london.env
zone='HllT:UK-LONDON-1-AD-1'
subnet='subnet-default'

shape='VM.Standard.E2.1.Micro'
spec='Intel.c2.1G.50Gb'
docs='https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm#Compute_Shapes'

# The image match string given references the first match
# obtained from ~/code/bashiform/oci/images

image='Canonical-Ubuntu-22.04-Minimal-20'
user_data='enable_root.sh'
```

The `box.env` file is minimal; `venue` references a file form a library of 
potential venues. Each box may have multiple venues to select from.

## Oracle Cloud

OCI is accessed though the `oci-cli` tool, which needs to be installed and configured
for your tenancy, including ssh identity-files for access.

```
oci setup config  # > ~/.oci/config
```

The default configuration is created in `.oci/config`, but any other environment can be used via:

```
~/code/bashaform/oci/use ~/.oci/my-config
```

## Example - honey pot

The honey-pot server once provisioned, is configured and managed through the `angelbox/nixbox` project. Here we just handle provisioning.

To show the whole lifecycle we begin by terminating the previous instance.

```
$ ~/code/bashaform/oci/action
Actions: ID|NAME|INFO|START|STOP|SOFTSTOP|RESET|SOFTRESET|SUSPEND|TERMINATE|STATUS|IP

$> ~/code/bashaform/oci/action terminate
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

```
$> ~/code/bashaform/oci/launch

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

As a result the instance is immediately available. (assuming that `.ssh/config` includes the ssh_config file via `Include ~/code/bashaform/*/*/*.ssh_config`), 

```
$> ssh honey.demo
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-1029-oracle x86_64)

root@honey1:~# 
```

## Install anything - self-extracting archive packages

A simple mechanism for installing an overlay of files onto the new system is provided via, `makeself` the self-extracting archive utility.

