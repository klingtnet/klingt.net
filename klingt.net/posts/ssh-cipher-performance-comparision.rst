.. title: SSH cipher performance comparision
.. slug: ssh-cipher-performance-comparision
.. date: 2014-10-19 13:34:10 UTC+02:00
.. tags: ssh, gnuplot, arcfour, cipher, comparision, aes, chacha20, python
.. link:
.. description: I've tried to measure the performance of different OpenSSH cipher algorithms using python.
.. type: text

OpenSSH disabled in ``sshd`` with version 6.6 some `unsafe algorithms <http://marc.info/?l=openssh-unix-dev&m=141264100821529&w=2>`_ by default:

    sshd(8): The default set of ciphers and MACs has been altered to remove unsafe algorithms. In particular, CBC ciphers and arcfour* are disabled by default.

This caused some trouble because I was using arcfour_ for performance reasons as default cipher for my remote backup machines in ``~/.ssh/config``. Now I need to reevaluate which cipher algorithm to use. Because I often do my backup via ``rsync`` over ssh I care most about transfer speed.

preparing a test
================

create a test file
------------------

At first we need a reasonably large file to transfer. That file must contain only random data to eliminate the possible influence of compression on the transfer rate. To do this simply use dd :code:`dd if=/dev/urandom of=/tmp/randomfile bs=1k count=1M`. This creates a file of 1GB size because the blocksize ``bs`` is 1000 and ``count`` blocks (1 million) are written. Because generating random data is expensive this could take some time, on my machine around 76s.

available cipher algorithms
---------------------------

To see which algorithms are available on client-side is dead easy:

.. code:: bash

    ssh -Q cipher

But that's not what we want, we need to know which of them are available on server-side, too. One way is to specify an unsupported algorithm, then the server will tell your which are avaible:

.. code:: bash

    ssh -c arcfour SERVER.

You can also do ``ssh -vv SERVER`` and read the logs. According to ``man ssh_config`` the default is (if not otherwise specified in your ``sshd_config``):

.. code:: bash

    aes128-ctr,aes192-ctr,aes256-ctr,
    aes128-gcm@openssh.com,aes256-gcm@openssh.com,
    chacha20-poly1305@openssh.com

test setup
----------

The transfer rates are simply determined by iterating over the available algorithms and sending the test file one or more times using the selected algorithm while measuring the transfer time.

.. code:: bash

    #!/bin/bash

    ALGS=( "aes128-ctr" "aes192-ctr" "aes256-ctr" "aes128-gcm@openssh.com" "aes256-gcm@openssh.com" "chacha20-poly1305@openssh.com" )

    for ALG in ${ALGS[@]}; do
        { time scp -c $ALG ./log.txt alinz.duckdns.org:/tmp ; } 2>> log.txt
    done

But why bothering with bash if you have the power of python™?

.. class:: strike

    To get similar conditions for every test run I will connect via cable to my server [1]_.

Before going further in the details, I have to say that I was really suprised by the benchmark results. I was firmly convinced that the choice of a fast cipher algorithm has `noticeably improved my transfer rates <https://bbs.archlinux.org/viewtopic.php?id=9107>`_. But my feeling has fooled me, the measurement showed that it *doesn't make any difference which algorithm you choose*, assuming that you have a reasonable amount of CPU power in relation to your network bandwidth. In my case this means that my `i5-2520M <http://ark.intel.com/de/products/52229/Intel-Core-i5-2520M-Processor-3M-Cache-up-to-3_20-GHz>`_ can handle ``scp`` over gigabit-ethernet without much effort. But if you still want to know what the benchmark results are, please read on.

using the loopback device
~~~~~~~~~~~~~~~~~~~~~~~~~

The idea was to ssh onto my own machine using the loopback device, eliminating the network bottleneck. To be able to do this I had to create another user to ssh into. Maybe you can skip the ``--create-home`` option because the test file is transfered to ``/tmp`` to prevent disk throttling by the SSD. In the normal case ``/tmp`` should be a RAM disk, you can check this by executing ``mount | grep -i /tmp`` which should show tmpfs_ as filesystem.

.. code:: bash

    sudo useradd --create-home cipherbench
    sudo passwd cipherbench
    sudo systemctl start sshd
    ssh cipherbench@localhost
    ssh-copy-id -i ~/.ssh/id_rsa.pub cipherbench@localhost

the benchmark script
--------------------

The following snippet shows the interesting part of the script where the time measurement takes place, lines 1 and 8. The script uses the `resource information package <https://docs.python.org/3/library/resource.html>`_ to get the time the subprocess call has used.

The full script can be downloaded from `here </files/ssh_bench.py>`_.

.. code-block:: python

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

To delete the :code:`cipherbench` user after running the script, execute the following commands:

.. code:: bash

    sudo userdel cipherbench
    sudo rm -r /home/cipherbench

results
-------

.. image:: /imgs/ssh_cipher_bench.png
    :class: kn-image

This is the code for generating the plot above.

.. code:: gnuplot

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


conclusion
~~~~~~~~~~

In short, if you care about speed don't use :code:`chacha20-poly1305@openssh.com`.

----

.. [1] This is the moment where I hate myself because I bought the `TP-Link WDR3500 <http://www.tp-link.com.de/products/details/?model=TL-WDR3500>`_ and not the `WDR3600 <http://www.tp-link.com.de/products/details/?model=TL-WDR3600>`_ which has gigabit-ethernet ports. On the other hand, I've saved 10 bucks.

.. _arcfour:    http://en.wikipedia.org/wiki/RC4
.. _tmpfs:      http://en.wikipedia.org/wiki/Tmpfs
