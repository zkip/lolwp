local ProviderProxy = require("utils/provider_proxy")

local function linear_compositor(self, key)
	local value = 0
	for _, provider in pairs(self.provider_list) do
		value = value + provider:GetValue(key)
	end
	return self.data[key] + value
end

return {
    sanity = function (host)
        return ProviderProxy.registry(host, { max = 0, current = 0 }, linear_compositor)
    end,
    
    health = function (host)
        return ProviderProxy.registry(host, { max = 0, current = 0 }, linear_compositor)
    end,
}