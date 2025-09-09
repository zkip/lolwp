require("class")

local People = Class(function (self, name)
	self.name = name
end)

function People:hello()
	print("hello ", self.name)
end

local people = People("SDFx")

local metatable = getmetatable(people)

local name_value = people.name
setmetatable(people, {
	__index = function (t, k)
		print("index::::::::", t, k)
		if k == "name" then
			return name_value .. "!!!!!!!"
		end
		return metatable[k]
	end,
	__newindex = function (t, k, v)
		print("newindex::::::::", t, k, v)
		if k == "name" and v ~= nil then
			name_value = v
			return
		end
		rawset(t, k, v)
	end
})

-- people.name = nil
rawset(people, "name", nil)
people.name = "sdf1"
people.name = nil
-- rawset(people, "name", nil)
people.name = "abc"

print(people.name)

local fff = {
	a = 1
}
local k,v = next(fff)
print(k,v )