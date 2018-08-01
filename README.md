# argon2

Tarantool C binding for the [Argon2] password hashing function.

### Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Documentation](#documentation)
- [Example](#example)
- [License](#license)

### Requirements

The module is self-contained.  
No external dependencies are needed to be installed on system.

[Back to TOC](#table-of-contents)

### Installation

This binding can be installed via [Tarantool Rocks](https://tarantool.io/en/download/rocks):

```bash
$ tarantoolctl rocks install argon2
```

Or by using the CMake (use the provided variables to point it to your Lua
and Argon2 installations):

```bash
$ cmake .
$ make
```

The CMake will fetch original argon2 C library from submodule,
build a static version of it (libargon2.a), then compile `argon2.so` Tarantool
binding module and link the original library statically into it.

[Back to TOC](#table-of-contents)

### Documentation

Original Lua binding author' documentation is available at
<http://thibaultcha.github.io/lua-argon2/>.

The Argon2 password hashing function documentation is available at
<https://github.com/P-H-C/phc-winner-argon2>.

[Back to TOC](#table-of-contents)

### Example

Hash a password to an encoded string:

```lua
local argon2 = require "argon2"
--- Prototype
-- local encoded, err = argon2.hash_encoded(pwd, salt, opts)

--- Argon2i
local encoded = assert(argon2.hash_encoded("password", "somesalt"))
-- encoded is "$argon2i$v=19$m=4096,t=3,p=1$c29tZXNhbHQ$iWh06vD8Fy27wf9npn6FXWiCX4K6pW6Ue1Bnzz07Z8A"

--- Argon2d
local encoded = assert(argon2.hash_encoded("password", "somesalt", {
  variant = argon2.variants.argon2_d
}))
-- encoded is "$argon2d$v=19$m=4096,t=3,p=1$c29tZXNhbHQ$2+JCoQtY/2x5F0VB9pEVP3xBNguWP1T25Ui0PtZuk8o"

--- Argon2id
local encoded = assert(argon2.hash_encoded("password", "somesalt", {
  variant = argon2.variants.argon2_id
}))
-- encoded is "$argon2id$v=19$m=4096,t=3,p=1$c29tZXNhbHQ$qLml5cbqFAO6YxVHhrSBHP0UWdxrIxkNcM8aMX3blzU"

-- Hashing options
local encoded = assert(argon2.hash_encoded("password", "somesalt", {
  t_cost = 4,
  m_cost = math.pow(2, 16), -- 65536 KiB
  parallelism = 2
}))
-- encoded is "$argon2i$v=19$m=65536,t=4,p=2$c29tZXNhbHQ$n6x5DKNWV8BOeKemQJRk7BU3hcaCVomtn9TCyEA0inM"

-- Changing the default options (those arguments are the current defaults)
argon2.t_cost(3)
argon2.m_cost(4096)
argon2.parallelism(1)
argon2.hash_len(32)
argon2.variant(argon2.variants.argon2_i)
```

Verify a password against an encoded string:

```lua
local argon2 = require "argon2"
--- Prototype
-- local ok, err = argon2.decrypt(hash, plain)

local encoded = assert(argon2.hash_encoded("password", "somesalt"))
-- encoded: argon2i encoded hash

local ok, err = argon2.verify(encoded, "password")
if err then
  error("could not verify: " .. err)
end

if not ok then
  error("The password does not match the supplied hash")
end
```

[Back to TOC](#table-of-contents)

### License

Work licensed under the MIT License. Please check
[P-H-C/phc-winner-argon2][Argon2] for the license over Argon2 and the reference
implementation.
