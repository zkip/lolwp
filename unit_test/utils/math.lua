setfenv(1, zkuires(
	"utils/math"
))

case("mod", function()
    expect(mod(11, 5), 1)
    expect(mod(-11, 5), -1)
end)