{
    "date": "2014-10-19",
    "description": "I've tried to measure the performance of different OpenSSH cipher algorithms using python.",
    "slug": "ssh-cipher-performance-comparision",
    "tags": "ssh, gnuplot, arcfour, cipher, comparision, aes, chacha20, python, arm",
    "title": "SSH cipher performance comparision"
}

OpenSSH disabled in `sshd` with version 6.6 some [unsafe
algorithms](http://marc.info/?l=openssh-unix-dev&m=141264100821529&w=2)
by default:

> sshd(8): The default set of ciphers and MACs has been altered to
> remove unsafe algorithms. In particular, CBC ciphers and arcfour\* are
> disabled by default.

This caused some trouble because I was using
[arcfour](http://en.wikipedia.org/wiki/RC4) for performance reasons as
default cipher for my remote backup machines in `~/.ssh/config`. Now I
need to reevaluate which cipher algorithm to use. Because I often do my
backup via `rsync` over ssh I care most about transfer speed.

Preparing a Test
================

Create a Test File
------------------

At first we need a reasonably large file to transfer. That file must
contain only random data to eliminate the possible influence of
compression on the transfer rate. To do this simply use dd
`dd if=/dev/urandom of=/tmp/randomfile bs=1k count=1M`.
This creates a file of 1GB size because the blocksize `bs` is 1000 and
`count` blocks (1 million) are written. Because generating random data
is expensive this could take some time, on my machine around 76s.

Available Cipher Algorithms
---------------------------

To see which algorithms are available on client-side is dead easy:

```bash
ssh -Q cipher
```

But that's not what we want, we need to know which of them are available
on server-side, too. One way is to specify an unsupported algorithm,
then the server will tell your which are avaible:

```bash
ssh -c arcfour SERVER.
```

You can also do `ssh -vv SERVER` and read the logs. According to
`man ssh_config` the default is (if not otherwise specified in your
`sshd_config`):

```bash
aes128-ctr,aes192-ctr,aes256-ctr,
aes128-gcm@openssh.com,aes256-gcm@openssh.com,
chacha20-poly1305@openssh.com
```

Test Setup
----------

The transfer rates are simply determined by iterating over the available
algorithms and sending the test file one or more times using the
selected algorithm while measuring the transfer time.

```bash
#!/bin/bash

ALGS=( "aes128-ctr" "aes192-ctr" "aes256-ctr" "aes128-gcm@openssh.com" "aes256-gcm@openssh.com" "chacha20-poly1305@openssh.com" )

for ALG in ${ALGS[@]}; do
    { time scp -c $ALG ./log.txt alinz.duckdns.org:/tmp ; } 2>> log.txt
done
```

But why bothering with bash if you have the power of python™?

<div class="strike">

To get similar conditions for every test run I will connect via cable to
my server [^1].

</div>

Before going further in the details, I have to say that I was really
suprised by the benchmark results. I was firmly convinced that the
choice of a fast cipher algorithm has [noticeably improved my transfer
rates](https://bbs.archlinux.org/viewtopic.php?id=9107). But my feeling
has fooled me, the measurement showed that it *doesn't make any
difference which algorithm you choose*, assuming that you have a
reasonable amount of CPU power in relation to your network bandwidth. In
my case this means that my
[i5-2520M](http://ark.intel.com/de/products/52229/Intel-Core-i5-2520M-Processor-3M-Cache-up-to-3_20-GHz)
can handle `scp` over gigabit-ethernet without much effort. But if you
still want to know what the benchmark results are, please read on.

### Using the Loopback Device

The idea was to ssh onto my own machine using the loopback device,
eliminating the network bottleneck. To be able to do this I had to
create another user to ssh into. Maybe you can skip the `--create-home`
option because the test file is transfered to `/tmp` to prevent disk
throttling by the SSD. In the normal case `/tmp` should be a RAM disk,
you can check this by executing `mount | grep -i /tmp` which should show
[tmpfs](http://en.wikipedia.org/wiki/Tmpfs) as filesystem.

```bash
sudo useradd --create-home cipherbench
sudo passwd cipherbench
sudo systemctl start sshd
ssh cipherbench@localhost
ssh-copy-id -i ~/.ssh/id_rsa.pub cipherbench@localhost
```

The Benchmark Script
--------------------

The following snippet shows the interesting part of the script where the
time measurement takes place, lines 1 and 8. The script uses the
[resource information
package](https://docs.python.org/3/library/resource.html) to get the
time the subprocess call has used.

The full script can be downloaded from [here](/files/ssh_bench.py).

```python
start = resource.getrusage(resource.RUSAGE_CHILDREN)
try:
    check_call(["scp", "-c", alg, src_file, "{}:{}".format(ssh_dest, file_dest)])
except CalledProcessError as e:
    print(e)
    exit(1)
else:
    fin = resource.getrusage(resource.RUSAGE_CHILDREN)
    results[alg].append(fin.ru_utime - start.ru_utime)
    call(["ssh", ssh_dest, "rm {}/{}".format(file_dest, src_file)])
```

To delete the `cipherbench` user after running the script,
execute the following commands:

```bash
sudo userdel cipherbench
sudo rm -r /home/cipherbench
```

Results
-------

![image](/imgs/ssh_cipher_bench.png){.kn-image}

This is the code for generating the plot above.

```gnuplot
set title 'ssh cipher benchmark'
set xlabel 'algorithm'
set ylabel 'mean time for 1GB testfile [s]'
set xtics rotate by -90
set grid
unset key   # disable legend
set style fill solid 1.0
set boxwidth 0.75
set term png size 900,900
set output 'bench.png'
plot 'bench.data' using ($0):1:($0):xtic(2) with boxes lc variable
# ($0) is pseudo column containing the row index, lc is linecolor
```

Conclusion
----------

In short, if you *care more about speed than security* and you have an
processor that *supports AES on hardware* as well as an OpenSSH
implementation that uses this CPU extension you shouldn't use
`chacha20-poly1305@openssh.com`.

### **Update 2015.01.12**

Arian Sanusi, one of my attentive readers, has commented that my
conclusion is only valid for CPUs with hardware AES extension. He has
made an similar benchmark on a *650MHz ARM Cortex A9* with NEON
extension and an OpenSSH rebuilt for this particluar SOC, obtaining the
following results:

```
52MB  10.5MB/s chacha20-poly1305@openssh.com
52MB   8.7MB/s aes128-ctr
52MB   6.5MB/s aes256-gcm@openssh.com
```

Like you can see, this is quite the inverted result. If you have a
[modern x86
processor](http://en.wikipedia.org/wiki/AES_instruction_set), nothing
older than the second generation of intel Core-I series for example, you
are likely to have AES optimizations built in your CPU [^2]. On Linux
you can check this by running `cat /proc/cpuinfo | grep aes`. You also
have to make sure that your OpenSSH implementation is build against
these optimizations to make use of them.

**Update 2015.08.31**
---------------------

Han-Kwang has stated that some modern Intel CPUs does not have hardware
AES support (see [^3]) and he's also made some benchmarks:

I test like this:

for ciph in "aes128-ctr" "aes192-ctr" "aes256-ctr"
<%22aes128-gcm@openssh.com>" <%22aes256-gcm@openssh.com>"
<%22chacha20-poly1305@openssh.com>" arcfour128 arcfour256 ; do echo -n
"\$ciph "; (time cat randomdata.bin randomdata.bin | ssh -c \$ciph
localhost wc -c) &gt;& sshlog && grep real sshlog | sed -e 's/\^.\*m//';
done

(Note that this avoids dealing with file writes. The randomdata.bin file
is small enough to be cached.)

On the i3 CPU, 100 MiB transfer:

```
aes128-ctr 1.091s
aes192-ctr 1.527s
aes256-ctr 1.357s
aes128-gcm@openssh.com 1.045s
aes256-gcm@openssh.com 1.335s
chacha20-poly1305@openssh.com 1.124s
arcfour128 0.926s
arcfour256 1.015s
```

(not so much difference between all the ciphers. Note that 1s/100 MiB is
about 50x slower than what your benchmark shows.)

On a VIA Eden 1 GHz CPU (1 thread), 5 MiB transfer:

```
aes128-ctr 4.673s
aes192-ctr 5.233s
aes256-ctr 5.764s
arcfour128 2.101s
arcfour256 2.105s
```

(older ssh version, does not have the latest ciphers available.
Arcfour/RC4 is significantly faster.)

On a VPS with 2 virtual cores Xeon E312xx (Sandy Bridge), with AES
support, 50 MiB transfer:

```
aes128-ctr 2.961s
aes192-ctr 3.035s
aes256-ctr 2.789s
arcfour128 2.712s
arcfour256 3.448s
```

------------------------------------------------------------------------

[^1]: This is the moment where I hate myself because I bought the
    [TP-Link
    WDR3500](http://www.tp-link.com.de/products/details/?model=TL-WDR3500)
    and not the
    [WDR3600](http://www.tp-link.com.de/products/details/?model=TL-WDR3600)
    which has gigabit-ethernet ports. On the other hand, I've saved 10
    bucks.

[^2]: Intel's ultra low power models (model name with prepended *U*) as
    well as the cheap Celeron's (maybe Pentium's, too) seem to not have
    hardware AES support.

[^3]: Intel's ultra low power models (model name with prepended *U*) as
    well as the cheap Celeron's (maybe Pentium's, too) seem to not have
    hardware AES support.
