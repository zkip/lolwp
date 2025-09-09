setfenv(1, zkuires(
	"utils/asserts"
))

case("isInteger", function()
    expect(isInteger(1.3), false)
    expect(isInteger(3), true)
end)

case("every", function()
    local is_eq_3 = function (n) return n > 3 end
    expect(every(is_eq_3, 1, 4, 3), false)
    expect(every(is_eq_3, 1, 2, 3), false)
    expect(every(is_eq_3, 5, 4, 9), true)
end)

case("some", function()
    local is_eq_3 = function (n) return n > 3 end
    expect(some(is_eq_3, 1, 4, 3), true)
    expect(some(is_eq_3, 1, 2, 3), false)
end)

case("notFalsy", function()
    expect(notFalsy(0), true)
    expect(notFalsy(false), false)
    expect(notFalsy(nil), false)
    expect(notFalsy(23), true)
    expect(notFalsy({}), true)
end)

case("isNil", function()
    expect(isNil(nil), true)
    expect(isNil(false), false)
    expect(isNil(0), false)
end)

case("notNil", function()
    expect(notNil(nil), false)
    expect(notNil(false), true)
    expect(notNil(0), true)
end)

case("noEmptyAry", function()
    expect(noEmptyAry({}), false)
    expect(noEmptyAry({3,4,false}), true)
    -- table counts is truncated by nil
    expect(noEmptyAry({nil}), false)
end)

case("isEmptyAry", function()
    expect(isEmptyAry({}), true)
    expect(isEmptyAry({3,'s'}), false)
    -- table counts is truncated by nil
    expect(isEmptyAry({nil}), true)
    expect(isEmptyAry({nil, false}), false)
end)