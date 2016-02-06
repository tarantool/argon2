local argon2 = require "argon2"

describe("encrypt()", function()
  it("should throw error on invalid argument", function()
    assert.has_error(function()
      argon2.encrypt(nil)
    end, "pwd must be a string")

    assert.has_error(function()
      argon2.encrypt("", nil)
    end, "salt must be a string")

    assert.has_error(function()
      argon2.encrypt("", "", {timeCost = ""})
    end, "Time cost must be a number")

    assert.has_error(function()
      argon2.encrypt("", "", {memoryCost = ""})
    end, "Memory cost must be a number")

    assert.has_error(function()
      argon2.encrypt("", "", {parallelism = ""})
    end, "Parallelism must be a number")
  end)
  it("should return a hash", function()
    local hash, err = argon2.encrypt("password", "somesalt")
    assert.falsy(err)
    assert.equal("$argon2i$m=12,t=2,p=1$c29tZXNhbHQ$ltrjNRFqTXmsHj++TFGZxg+zSg8hSrrSJiViCRns1HM", hash)
  end)
  it("should hash with argon2d", function()
    local hash, err = argon2.encrypt("password", "somesalt", {argon2d = true})
    assert.falsy(err)
    assert.is_string(hash)
    assert.truthy(string.match(hash, "argon2d"))
  end)
  it("salt too short", function()
    local hash, err = argon2.encrypt("password", "")
    assert.falsy(hash)
    assert.equal("Salt is too short", err)

    hash, err = argon2.encrypt("password", "abcdefg")
    assert.falsy(hash)
    assert.equal("Salt is too short", err)
  end)
  it("should accept time cost", function()
    local hash, err = argon2.encrypt("password", "somesalt", {timeCost = 4})
    assert.falsy(err)
    assert.is_string(hash)
    assert.truthy(string.match(hash, "t=4"))
  end)
  it("should accept memory cost", function()
    local hash, err = argon2.encrypt("password", "somesalt", {memoryCost = 13})
    assert.falsy(err)
    assert.is_string(hash)
    assert.truthy(string.match(hash, "m=13"))
  end)
  it("should accept parallelism", function()
    local hash, err = argon2.encrypt("password", "somesalt", {parallelism = 2, memoryCost = 24})
    assert.falsy(err)
    assert.is_string(hash)
    assert.truthy(string.match(hash, "p=2"))
  end)
  it("should accept all options", function()
    local hash, err = argon2.encrypt("password", "somesalt", {
      timeCost = 4,
      memoryCost = 24,
      parallelism = 2
    })
    assert.falsy(err)
    assert.is_string(hash)
    assert.truthy(string.match(hash, "m=24,t=4,p=2"))
  end)
end)

describe("verify()", function()
  it("should verify ok", function()
    local hash, err = argon2.encrypt("password", "somesalt")
    assert.falsy(err)

    local ok, err = argon2.verify(hash, "password")
    assert.falsy(err)
    assert.True(ok)
  end)
  it("should verify fail", function()
    local hash, err = argon2.encrypt("password", "somesalt")
    assert.falsy(err)

    local ok, err = argon2.verify(hash, "passworld")
    assert.False(ok)
    assert.equal("The password did not match.", err)
  end)
  it("should verify argon2d ok", function()
    local hash, err = argon2.encrypt("password", "somesalt", {argon2d = true})
    assert.falsy(err)

    local ok, err = argon2.verify(hash, "password")
    assert.falsy(err)
    assert.True(ok)
  end)
  it("should verify argon2d fail", function()
    local hash, err = argon2.encrypt("password", "somesalt", {argon2d = true})
    assert.falsy(err)

    local ok, err = argon2.verify(hash, "passworld")
    assert.False(ok)
    assert.equal("The password did not match.", err)
  end)
end)
