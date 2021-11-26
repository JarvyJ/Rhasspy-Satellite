From a clean git clone, do the following:

```bash
git submodule init
git submodule update
```

and from there to update Rhasspy/SkiffOS to a specific release:
```bash
cd skiffos
git checkout tags/{released tag}
```

Back out to the main rhasspy-satellite directory, check in the changes and you should be good to go!
