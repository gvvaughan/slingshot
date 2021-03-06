# Slingshot NEWS - User visible changes.

## Noteworthy changes in release ?.? (????-??-??) [?]

### New Features

  - Support for automated `make installcheck` rules to make sure both
    LuaRocks and configured installations are not borked.

    Be careful not to undermine these rules by putting any `package.path`
    and `package.cpath` munging designed to point specl an the uninstalled
    tree inside a guard such as:

    ```lua
       if os.getenv "installcheck" == nil then
         -- add build-tree directories to package.path et. al.
       end
    ```

### Bug Fixes

  - Travis now builds lua with LUA_COMPAT_5_2 defined for maximum
    backwards compatibility in Lua 5.3 builds.

  - Don't clobber release directory link when unpacking dist tarball
    during check-in-release-branch.


## Noteworthy changes in release 8.0.0 (2014-12-31) [stable]

### New Features:

  - Libtool built Lua modules should be appended to luaexec_LTLIBRARIES,
    where non LuaRocks users will receive them in the correct directory
    (likely already in their LUA_CPATH) after `sudo make install`.

  - Slingshot now supports the slack.com Travis Integration.  Add
    a .slackid file to the root of your project, containing your slack
    token on a single line -- a notification section containing that
    id will be appended to your `.travis.yml` at configure time.

  - Various build related directories are added to SPECL_ENV by default,
    so that package.path and package.cpath settings can be set in your
    spec_helper.lua to enforce loading from the build tree instead of
    accidentally falling back to the system module paths -- especially
    during the VPATH `make check` performed during `make distcheck`. You
    might want to write something like this in `spec_helper.lua`:

    ```lua
        local std = require "specl.std"

        local builddir = os.getenv "top_builddir" or "."
        local srcdir = os.getenv "top_srcdir" or "."

        package.path = std.package.normalize (
                         top_builddir .. "/lib/mymodule/?.lua",
                         top_srcdir .. "/lib/mymodule/?.lua",
                         package.path)

        mymodule = require "mymodule"
    ```

    This ensures that, no matter what LuaRocks does to the package paths,
    nor whether you run `specl` by hand with auto-discovery, or via the
    `make check` or `make distcheck` rules... by the time you require
    your module from the development tree, the package path has the right
    directories at the front.

  - Unused libtool .la files for Lua modules are no longer installed.

  - Update to latest upstream `ax_lua.m4`.

  - Update to latest upstream `bootstrap`.

  - Travis CI overhaul: Uses latest LuaRocks 2.2.0 with each of Lua
    5.3.0(rc1), 5.2.3, 5.1.5 and luajit-2.0.3, only building the Lua
    version needed in each run.  We also run `make syntax-check` on the
    CI server after successful tests.

  - Instead of overwriting .travis.yml unconditionally, show a warning
    explaining how to update it when it changes, like bootstrap.

  - Markdown format NEWS and announcements.

### Incompatible Changes:

  - SPECL_ENV is now set (to empty) by default, and should be augmented
    with += in local.mk.

  - SS_CONFIG_TRAVIS is no longer supported.  Any additional travis rocks
    you were passing there should now be listed in a travis_extra_rocks
    variable in `bootstrap.conf` instead.

### Bug Fixes:

  - We no longer assume autotooled installations will put modules in
    --libdir (although that will continue to work), but also set
    luaexecdir at install-time for `ax_lua.m4` compatibility.

  - Version comparison in `build-aux/do-release-commit-and-tag` now
    works correctly.

  - bootstrap now updates only gnulib and slingshot git submodules as
    expected.

  - Slingshot bootstrap really does perform an automatic out of date
    check of client bootstrap against latest slingshot submodule
    bootstrap script now - after updating to this version!


## Noteworthy changes in release 7 (2014-07-31) [stable]

### New Features:

  - Slingshot `make release` now requires a LuaRocks binary that supports
    the upload command (such as the 2.2.0 beta release) and uses that to
    upload rockspecs directly to the moonrocks repository, rather than
    emailing the luarocks-developer list with an upload request.  If the
    upload fails due to a missing api-key, then make sure you have one
    at rocks.moonscript.org/settings and call make like this:

    ```
        make upload API_KEY=0123456789abcdefghijklmnopqrstuvwxyzABCDE
    ```

  - `mkrockspecs` accepts a new `--branch` option for generating a
    git/scm rockspec that pulls that branch instead of master.

  - `mkrockspecs` accepts a new `--repository` option to cope with
    releasing a LuaRock from a repository with a different name, e.g:
    `stdlib-36-1.rockspec` from `http://github.com/rrthomas/lua-stdlib`.

  - Slingshot bootstrap will check rockspecs listed in $buildreq,
    according to the URL part of a specification-triple ending in
    `.rockspec`.  So that we don't have to install, say, LDoc twice for
    Travis (once in the system rocks tree so that bootstrap won't bomb
    out with a missing rockspec error, and then again in the project
    rocks tree after luarocks-config.ld has been built by make), the
    rockspec version checks can be short-circuited by setting an APPVAR
    in bootstrap's environment, e.g:

    ```bash
        LDOC=`pwd`/luarocks/bin/ldoc ./bootstrap
    ```

  - Slingshot bootstrap accepts a new `--luarocks-tree` option to
    check a particular tree for prerequisite rocks.

  - `build-aux/merge-sections` has a new `--verbose` flag that reports
    progress to stderr in real time.

  - Remove m4/ax_compare_version.m4 and dependencies, resulting in a
    slightly faster and smaller configure.

### Bugs fixed:

  - `bootstrap` now has `slingshot_copy` merged in correctly.

  - `mkrockspecs` generates build.modules keys correctly for the
    `foo/bar/init.lua` pattern.


## Noteworthy changes in release 6 (2014-01-04) [stable]

### New Features:

  - A manually entered list of modules in rockspec.conf now
    creates "builtin" autoconfless builds in the main rockspec
    just as if --module-dir had been passed.
  - Support running `make check` on installed packages, where the
    checks require access to resources not visible in the install
    tree (e.g. installed specl has all lua sources inlined, rather
    than in an installed subtree, but unit tests need access to the
    module subtree which is only visible in the build directory).

### Incompatible Changes:

  - `bootstrap.slingshot` is now automatically merged into the
    `bootstrap` script, so you shouldn't copy it into your project
    tree anymore, or add the glue to run it to your `bootstrap.conf`.


## Noteworthy changes in release 5 (2013-12-08) [stable]

### New Features:

  - The announcement message is formatted for easier pasting into
    github release notes.
  - Mkrockspecs sorts table keys in generated rockspecs, so that
    contents of build.modules is in order, for example.
  - Travis builds will now use the latest upstream luarocks 2.1.1
    release.

### Bugs fixed:

  - Specifying additional SPECL_OPTS in local.mk now works properly.
  - Announcement message shows luarocks install command correctly.
  - Travis builds now use the correct version of Lua for local
    luarocks installation, so compiled dependency rocks actually
    work.
  - Fixed a typo in maint.mk no-submodule-changes rule.


## Noteworthy changes in release 4 (2013-08-29) [stable]

### New Features:

  - mkrockspecs uses luaposix to search the module root tree for lua
    sources if it is available, which is a lot faster than spawning
    a shell to list the contents of each subdirectory, and reading the
    results back over a pipe.

### Bugs Fixed:

  - Submodules pulled to the release branch are removed before unpacking
    the release tarball.
  - `make syntax-check` ignores submodule directories.
  - Scm rockspecs are now correctly copied to the release branch.
  - No longer leaves trailing whitespace in .travis.yml where there are
    no additional luarocks to install.
  - No longer reinstalls the slingshot client package on Travis.
  - Fixed many fine typos.


## Noteworthy changes in release 3 (2013-05-19) [stable]

### New Features:

  - Support Specl automation with `include build-aux/specl.mk`

  - No longer using hobbled "foreign" mode.  README is distributed
    in release tarballs, but README.md maintained in the repo for
    prettier output on github.

  - Support `--module-dir ROOT` option to `mkrockspecs` to
    specify the root of a tree of `.lua` files for a LuaRocks
    "builtin" build.type installation.  Pass the new option to
    Slingshot mkrockspec invocations setting `mkrockspecs_args`
    appropriately in your `local.mk`:

    ```
      mkrockspecs_args = --module-dir lib
    ```

  - Works with lyaml 4 and newer, which now returns all documents
    in the YAML stream as a table.

### Bugs Fixed:

  - Don't forget to distribute .autom4te.cfg file.

  - If either luadoc or ldoc are specified in SS_CONFIG_TRAVIS,
    perform a segregated 5.1 install with the system luarocks to
    avoid incompatibilities on Travis CI.

### Incompatible Changes:

  - `mail` wrapper removed.  Rockspec announcement sent with a link
    to the rockspec rather than as an attachment.


## Noteworthy changes in release 2 (2013-04-28) [beta]

### New Features:

  - No longer depend on `woger`.

  - New `mail` wrapper script to provide a POSIX mail API wrapped
    around mutt.  Currently Mac OS X specific (which is the main
    system that doesn't ship a POSIX mail compatible command).

  - Split local and origin rules to support, eg:

    ```
      $ make beta
        # manually check local trees...
      $ make push
        # manually check github zipball and released rockspec files...
        # manually edit ~/announce-<package>-<version>...
      $ make mail
   ```

  - Port of gnulib project sanity checks hooked into release
    rules by `include build-aux/sanity.mk`.

### Bugs Fixed:

  - Newly created release branch is now branched from the v1 tag rather
    than the "Post-release administrivia" commit.
  - Include maintainer support files in release, so that Travis CI has
    everything it needs to work on the release branch too.


## Noteworthy changes in release 1 (2013-04-28) [beta]

  - Initial proof-of concept for shared Lua RockSpec framework.
