# Simple oci scripts

```
$> ~/code/nixbox/scripts/oci/status
+------------+---------+
| Name       | State   |
+------------+---------+
| honey1     | RUNNING |
| nameserver | RUNNING |
| field1     | RUNNING |
+------------+---------+
```

```
$ ~/code/nixbox/scripts/oci/action ip honey1
honey1 140.238.86.40
```

These scripts assume that .oci/config has been set up with
the tenancy and user OCID's

The environment setting script `use` can be sourced with
an alternative tenancy/compartment configuration.

```
source ~/nixbox/scripts/oci/env .oci/config.PROD
```

# Scripts per-instance

By default these scripts take parameters from the $PWD context, e.g.

```
cd .ssh/nixbox-conf/demo/boxes/honey1.demo
~/code/nixbox/scripts/oci/action ip
honey1 140.238.86.40
```

# Launch Instance

```
$> cd .ssh/nixbox-conf/demo/boxes/honey1.demo
$> cat oci.env

shape='VM.Standard.E2.1.Micro'
image='Canonical-Ubuntu-22.04-Minimal-2023.02.14-0'
zone='HllT:UK-LONDON-1-AD-2'

$> ~/code/nixbox/scripts/oci/create
honey1 140.238.86.40
```
