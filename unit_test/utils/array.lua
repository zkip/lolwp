setfenv(1, zkuires(
	"utils/array"
))

case("getn", function()
    local ary = {1, 2, 3}
    expect(getn(ary, 1), 1)
    expect(getn(ary, -1), 3)
    expect(getn(ary, -3), 1)
end)

case("reverseGet", function()
    local ary = {1, 2, 3}
    expect(reverseGet(ary, 1), 3)
    expect(reverseGet(ary, 2), 2)
    expect(reverseGet(ary, -1), 1)
    expect(reverseGet(ary, -3), 3)
    expect(reverseGet(ary, -2), 2)
end)

case("flattern", function()
	local x = { 1, 2, 3 }
    local ary = { 1, { 2, 4, 6}, 3, { 9, x } }

    let(flattern(ary)).shallowEqual({ 1, 2, 4, 6, 3, 9, x })
end)

case("flattern_", function()
	local x = { 1, 2, 3 }
    local ary = { 1, { 2, 4, 6}, 3, { 9, x } }

    let(flattern_(unpack(ary))).shallowEqual({ 1, 2, 4, 6, 3, 9, x })
end)
