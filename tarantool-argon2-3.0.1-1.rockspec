package = "tarantool-argon2"
version = "3.0.1-1"
source = {
    url = "git://github.com/asverdlov/lua-argon2",
    tag = "3.0.1"
}
description = {
    summary = "Lua C binding for the Argon2 password hashing function",
    homepage = "https://github.com/thibaultcha/lua-argon2",
    license = "MIT"
}
dependencies = {
    "lua >= 5.1"
}
build = {
    type = "cmake",
    variables = {
        CMAKE_BUILD_TYPE="RelWithDebInfo";
        CMAKE_INSTALL_PREFIX = "$(PREFIX)",
        TARANTOOL_INSTALL_LIBDIR = "lib",
        TARANTOOL_INSTALL_LUADIR = "lua",
    };
}
