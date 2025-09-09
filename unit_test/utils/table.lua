setfenv(1, zkuires(
	"utils/table"
))

case("getByKeypath", function ()
	local a = {
		b = {
			c = {
				name = 'bingo'
			}
		}
	}

	local d, p, k = getByKeypath(a, 'b.c.name')
	expect(d, 'bingo')
	expect(p, a.b.c)
	expect(k, 'name')

	local d, p, k = getByKeypath(a, '.b.c.')
	expect(d, a.b.c)
	expect(p, a.b)
	expect(k, 'c')

	local d, p, k = getByKeypath(a, 'b.c.e')
	expect(d, nil)
	expect(p, a.b.c)
	expect(k, 'e')

	local d, p, k = getByKeypath(a, 'b.1.c.e.f')
	expect(d, nil)
	expect(p, a.b)
	expect(k, '1')
end)

case("access.get", function ()
	local a = {
		b = {
			c = {
				name = 'bingo'
			}
		}
	}

	local d, p, k = access(a).get("b.c.name")
	expect(d, 'bingo')
	expect(p, a.b.c)
	expect(k, 'name')
end)

case("access.set", function ()
	local a = {
		b = {
			c = {
				name = 'bingo'
			}
		}
	}

	access(a).set("b.c.name", 'xxx')
	expect(a.b.c.name, 'xxx')

	access(a).set("s", 'xxx')
	expect(a.s, 'xxx')

	access(a).set("s.e", 'xxx')
	expect(a.s.e, nil)
	expect(access(a).get("s.e"), nil)

	access(a).set("x.xx.xxx.xxxx", 'xxx')
	expect(a.x.xx.xxx.xxxx, 'xxx')
end)

case("access.delta", function ()
	local a = {
		b = {
			c = {
				num = 13
			}
		}
	}

	access(a).delta("b.c.num", 11)
	expect(a.b.c.num, 24)
	access(a).delta("b.c.num", -2)
	expect(a.b.c.num, 22)

	access(a).delta("b.x", 3, 2)
	expect(a.b.x, 5)
end)

case("access.multiple", function ()
	local a = {
		b = {
			c = {
				num = 13
			}
		}
	}

	access(a).multiple("b.c.num", 2)
	expect(a.b.c.num, 26)
	access(a).multiple("b.c.num", 0.5)
	expect(a.b.c.num, 13)

	access(a).multiple("b.x", 3, 2)
	expect(a.b.x, 6)
end)

case("access.divide", function ()
	local a = {
		b = {
			c = {
				num = 8
			}
		}
	}

	access(a).divide("b.c.num", 2)
	expect(a.b.c.num, 4)
	access(a).divide("b.c.num", 0.5)
	expect(a.b.c.num, 8)

	access(a).divide("b.x", 2, 6)
	expect(a.b.x, 3)
end)

case("access.mutate", function ()
	local a = {
		b = {
			c = {
				num = 8
			}
		}
	}

	access(a).mutate("b.c.num", function (value) return value + 3 end)
	expect(a.b.c.num, 11)

	access(a).mutate("b.x", function (value) return (value or 4) * 3 end)
	expect(a.b.x, 12)
end)

case("access.call", function ()
	local a = {
		b = {
			c = {
				name = 'bingo'
			}
		}
	}

	function a.b.c:GetName()
		return self.name
	end

	local xxx = access(a).call
	local d = xxx("b.c.GetName")
	expect(xxx("b.c.GetName"), "bingo")
	local d = access(a).call("b.1.c.GetName")
	expect(d, nil)
	local d = access(a).call("b.c.GetName3")
	expect(d, nil)
end)

case("hasSome", function ()
	expect(hasSome({ }), false)
	expect(hasSome({ [2] = 34 }), true)
	expect(hasSome({ [false] = 1 }), true)
	expect(hasSome({ [false] = nil }), false)
	expect(hasSome({ [2] = nil }), false)
end)