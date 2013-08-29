package = "slingshot"
version = "git-1"
description = {
  homepage = "http://github.com/gvvaughan/slingshot",
  license = "MIT/X11, GPLv3+",
  summary = "Slingshot releases rocks!",
  detailed = "A framework for automatic rockspecs creation and simplified release thereof.",
}
source = {
  url = "git://github.com/gvvaughan/slingshot.git",
}
dependencies = {
  "lua >= 5.1",
  "lyaml",
}
external_dependencies = nil
build = {
  build_command = "./bootstrap && ./configure LUA='$(LUA)' LUA_INCLUDE='-I$(LUA_INCDIR)' --prefix='$(PREFIX)' --libdir='$(LIBDIR)' --datadir='$(LUADIR)' && make clean all",
  type = "command",
  copy_directories = {},
  install_command = "make install luadir='$(LUADIR)'",
}
