setfenv(1, zkuires(
	"utils/string"
))

case("tofixed", function ()
	local n = 1.633634234
	expect(tofixed(3, n), "1.634")
	expect(tofixed(n), "1.63")
	expect(tofixed(1, n), "1.6")
	expect(tofixed(0, n), "2")
	expect(tofixed(3, 2), "2.000")
end)