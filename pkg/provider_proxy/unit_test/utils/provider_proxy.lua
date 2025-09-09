setfenv(1, zkuires(
	{ ProviderProxy = "utils/provider_proxy" }
))

local Host = Class(function (self, args)
	self.max = args.max
	self.current = args.current
end)

local function compositor(self, key)
	local value = 0
	for _, provider in pairs(self.provider_list) do
		value = value + provider:GetValue(key)
	end
	return self.data[key] + value
end

case("GetRawValue", function ()
	local host = Host { max = 120, current = 100 }

	local provider = ProviderProxy.registry(host, { max = 0, current = 0 }, compositor)

	expect(provider:GetRawValue("max"), 120)
	expect(provider:GetRawValue("current"), 100)
	expect(host.max, 120)
	expect(host.current, 100)
end)

case("Commit", function ()
	local host = Host { max = 120, current = 100 }

	local provider = ProviderProxy.registry(host, { max = 0, current = 0 }, compositor)

	provider:Commit("max", 40)
	provider:Commit("max", 50)
	provider:Commit("current", 80)
	provider:Commit("current", 30)
	provider:Commit("current", 30)

	expect(host.max, 170)
	expect(host.current, 130)
	expect(provider:GetRawValue("max"), 120)
	expect(provider:GetRawValue("current"), 100)
end)

case("Host Data Modify", function ()
	local host = Host { max = 120, current = 100 }

	local provider = ProviderProxy.registry(host, { max = 0, current = 0 }, compositor)

	provider:Commit("max", 100)
	provider:Commit("current", 20)

	host.max = 400
	host.current = 200

	expect(host.max, 500)
	expect(host.current, 220)
end)

case("Initial Provider Value", function ()
	local host = Host { max = 120, current = 100 }

	local provider = ProviderProxy.registry(host, { max = 30, current = 20 }, compositor)

	expect(host.max, 150)
	expect(host.current, 120)

	provider:Commit("max", 100)
	provider:Commit("current", 50)

	expect(host.max, 220)
	expect(host.current, 150)

	host.max = 400
	host.current = 200

	expect(host.max, 500)
	expect(host.current, 250)
end)