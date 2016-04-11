{
    "date": "2016-02-27",
    "description": "How to downgrade any arch linux package.",
    "slug": "how-to-downgrade-any-arch-linux-package",
    "tags": "arch, linux, downgrade, package, pacman",
    "title": "How to Downgrade any Arch Linux Package"
}

- go to the [Arch Linux Archive](https://archive.archlinux.org/) and find the package version you want to install
- let's say that I want to downgrade [SANE](http://www.sane-project.org/intro.html) to `1.0.24-4`:
    - the sane package is located under [`/packages/s/sane`](https://archive.archlinux.org/packages/s/sane/)
    - download the package: `curl --remote-name -Lsf 'https://archive.archlinux.org/packages/s/sane/sane-1.0.24-4-x86_64.pkg.tar.xz'`
    - install it: `sudo pacman -U sane-1.0.24-4-x86_64.pkg.tar.xz`
    - done!
    - to ignore a specific package when you run a pacman update use the `--ignore` switch: `pacman -Syu --ignore sane`

- for more information, how to restore all your packages at a specific date amongst other, take a look at the [wiki](https://wiki.archlinux.org/index.php/Arch_Linux_Archive)
