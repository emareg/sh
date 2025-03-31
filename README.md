Nice scripts that run from any shell with Internet and curl.

Call like this

```
curl -sS sh.emareg.de/setup.sh | bash
curl -sS sh.emareg.de/sysinfo.sh | bash
curl -sS sh.emareg.de/sysinfo.sh | bash -s [sys|cpu|net|mem]
```

If you only have wget, run `wget -qO - sh.emareg.de/sysinfo.sh | bash`

GitHub: [https://github.com/emareg/sh](https://github.com/emareg/sh)
