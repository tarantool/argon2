local argon2 = require "argon2"

describe("argon2", function()
  it("_VERSION field", function()
    assert.equal("1.1.1", argon2._VERSION)
  end)
  it("_AUTHOR field", function()
    assert.equal("Thibault Charbonnier", argon2._AUTHOR)
  end)
  it("_LICENSE field", function()
    assert.equal("MIT", argon2._LICENSE)
  end)
  it("_URL field", function()
    assert.equal("https://github.com/thibaultCha/lua-argon2", argon2._URL)
  end)
end)

describe("encrypt()", function()
  it("should throw error on invalid argument", function()
    assert.has_error(function()
      argon2.encrypt(nil)
    end, "bad argument #1 to 'encrypt' (string expected, got nil)")

    assert.has_error(function()
      argon2.encrypt("", nil)
    end, "bad argument #2 to 'encrypt' (string expected, got nil)")

    assert.has_error(function()
      argon2.encrypt("", "", "")
    end, "bad argument #3 to 'encrypt' (expected to be a table)")

    assert.has_error(function()
      argon2.encrypt("", "", {t_cost = ""})
    end, "bad argument #3 to 'encrypt' (expected t_cost to be a number, got string)")

    assert.has_error(function()
      argon2.encrypt("", "", {m_cost = ""})
    end, "bad argument #3 to 'encrypt' (expected m_cost to be a number, got string)")

    assert.has_error(function()
      argon2.encrypt("", "", {parallelism = ""})
    end, "bad argument #3 to 'encrypt' (expected parallelism to be a number, got string)")

    assert.has_error(function()
      argon2.encrypt("", "", {}, "")
    end, "bad argument #4 to 'encrypt' (found too many arguments)")
  end)
  it("salt too short", function()
    local hash, err = argon2.encrypt("password", "")
    assert.falsy(hash)
    assert.equal("Salt is too short", err)

    hash, err = argon2.encrypt("password", "abcdefg")
    assert.falsy(hash)
    assert.equal("Salt is too short", err)
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
  it("should accept time cost", function()
    local hash, err = argon2.encrypt("password", "somesalt", {t_cost = 4})
    assert.falsy(err)
    assert.is_string(hash)
    assert.truthy(string.match(hash, "t=4"))
  end)
  it("should accept memory cost", function()
    local hash, err = argon2.encrypt("password", "somesalt", {m_cost = 13})
    assert.falsy(err)
    assert.is_string(hash)
    assert.truthy(string.match(hash, "m=13"))
  end)
  it("should accept parallelism", function()
    local hash, err = argon2.encrypt("password", "somesalt", {parallelism = 2, m_cost = 24})
    assert.falsy(err)
    assert.is_string(hash)
    assert.truthy(string.match(hash, "p=2"))
  end)
  it("should accept all options", function()
    local hash, err = argon2.encrypt("password", "somesalt", {
      t_cost = 4,
      m_cost = 24,
      parallelism = 2
    })
    assert.falsy(err)
    assert.is_string(hash)
    assert.truthy(string.match(hash, "m=24,t=4,p=2"))
  end)
end)

describe("verify()", function()
  it("should throw error on invalid argument", function()
    assert.has_error(function()
      argon2.verify(nil)
    end, "bad argument #1 to 'verify' (string expected, got nil)")

    assert.has_error(function()
      argon2.verify("", nil)
    end, "bad argument #2 to 'verify' (string expected, got nil)")

    assert.has_error(function()
      argon2.verify("", "", "")
    end, "bad argument #3 to 'verify' (found too many arguments)")
  end)
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

describe("module settings", function()
  it("should throw error on invalid argument", function()
    assert.has_error(function()
      argon2.t_cost(0, 0)
    end, "bad argument #2 to 't_cost' (found too many arguments)")

    assert.has_error(function()
      argon2.t_cost ""
    end, "bad argument #1 to 't_cost' (expected t_cost to be a number, got string)")

    assert.has_error(function()
      argon2.argon2d(0, 0)
    end, "bad argument #2 to 'argon2d' (found too many arguments)")

    assert.has_error(function()
      argon2.argon2d "idk"
    end, "bad argument #1 to 'argon2d' (invalid option 'idk')")
  end)
  it("should accept t_cost module setting", function()
    assert.equal(4, argon2.t_cost(4))

    local hash, err = argon2.encrypt("password", "somesalt")
    assert.falsy(err)
    assert.equal("$argon2i$m=12,t=4,p=1$c29tZXNhbHQ$MqR/dijhlwUxpBbn/OQthUlTeP7xTWkksfxDMmFTyo8", hash)

    hash, err = argon2.encrypt("password", "somesalt", {t_cost = 2})
    assert.falsy(err)
    assert.equal("$argon2i$m=12,t=2,p=1$c29tZXNhbHQ$ltrjNRFqTXmsHj++TFGZxg+zSg8hSrrSJiViCRns1HM", hash)

    finally(function()
      argon2.t_cost(2)
    end)
  end)
  it("should accept m_cost module setting", function()
    assert.equal(24, argon2.m_cost(24))

    local hash, err = argon2.encrypt("password", "somesalt")
    assert.falsy(err)
    assert.equal("$argon2i$m=24,t=2,p=1$c29tZXNhbHQ$yU2I2AEwQ0KmHKOML+JQ+zlBWUKUcLkiacnz7gl+d+g", hash)

    hash, err = argon2.encrypt("password", "somesalt", {m_cost = 12})
    assert.falsy(err)
    assert.equal("$argon2i$m=12,t=2,p=1$c29tZXNhbHQ$ltrjNRFqTXmsHj++TFGZxg+zSg8hSrrSJiViCRns1HM", hash)

    finally(function()
      argon2.m_cost(12)
    end)
  end)
  it("should accept parallelism", function()
    assert.equal(2, argon2.parallelism(2))

    local hash, err = argon2.encrypt("password", "somesalt")
    assert.falsy(err)
    assert.equal("$argon2i$m=12,t=2,p=2$c29tZXNhbHQ$JH4TagIUwH4IQpYzwU5o8jUntm1yOswsoCdgQCv9JNw", hash)

    hash, err = argon2.encrypt("password", "somesalt", {parallelism = 1})
    assert.falsy(err)
    assert.equal("$argon2i$m=12,t=2,p=1$c29tZXNhbHQ$ltrjNRFqTXmsHj++TFGZxg+zSg8hSrrSJiViCRns1HM", hash)

    finally(function()
      argon2.parallelism(1)
    end)
  end)
  it("should accept argon2d", function()
    assert.equal("off", argon2.argon2d("off"))
    assert.equal("on", argon2.argon2d("on"))
    assert.equal(false, argon2.argon2d(false))
    assert.equal(true, argon2.argon2d(true))

    local hash, err = argon2.encrypt("password", "somesalt")
    assert.falsy(err)
    assert.equal("$argon2d$m=12,t=2,p=1$c29tZXNhbHQ$mfklun4fYCbv2Hw0UnZZ56xAqWbjD+XRMSN9h6SfLe4", hash)

    hash, err = argon2.encrypt("password", "somesalt", {argon2d = false})
    assert.falsy(err)
    assert.equal("$argon2i$m=12,t=2,p=1$c29tZXNhbHQ$ltrjNRFqTXmsHj++TFGZxg+zSg8hSrrSJiViCRns1HM", hash)
  end)
end)

