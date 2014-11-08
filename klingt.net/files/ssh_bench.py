#!/usr/bin/env python3

# note that resource is unix specific
import resource
from subprocess import check_call, call, CalledProcessError
from sys import exit

def main():
    algs = ["aes128-ctr",
        "aes192-ctr",
        "aes256-ctr",
        "aes128-gcm@openssh.com",
        "aes256-gcm@openssh.com",
        "chacha20-poly1305@openssh.com"]
    src_file = "randomfile"
    ssh_dest = "cipherbench@localhost"
    file_dest = "/tmp"
    log_file = "bench.data"
    max_repeats = 5
    results = {}
    for alg in algs:
        results[alg] = []
        print('{} ...'.format(alg))
        for i in range(max_repeats):
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
    with open('bench.data', 'w') as f:
        f.write('#' + '\t'.join(algs) + '\n')
        for alg in algs:
            f.write('{}\t'.format(arith_mean(results[alg])))

# arithmetic mean
def arith_mean(list):
    return sum(list) / len(list)

if __name__ == "__main__":
    main()
