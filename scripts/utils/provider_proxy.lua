
local Provider = Class(function (self, raw_data, init_provider_value, on_clean)
    self.data = init_provider_value

    self.raw_data = raw_data
    self.on_clean = on_clean
end)

function Provider:Commit(key, value)
    if self.data[key] == nil then return end

    self.data[key] = value
end

function Provider:GetValue(key)
    return self.data[key]
end

function Provider:GetRawValue(key)
    return self.raw_data[key]
end

function Provider:Clean()
    self:on_clean()
end

local ProviderProxy = Class(function (self, host, keys_and_provider_init_value, compositor)
    self.host = host
    self.data = { }
    self.provider_list = { }

    for key, provider_init_value in pairs(keys_and_provider_init_value) do
        self.data[key] = host[key]
        rawset(host, key, nil)
    end

	local metatable = getmetatable(host)
	-- 定义 Class 时不传 props 的模式
	local is_class_self = metatable.__index == metatable

	local __index = function(t, k)
		if self.data[k] ~= nil then return compositor(self, k) end

		if is_class_self then
			return metatable[k]
		else
			return metatable.__index(t, k)
		end
	end

	local __newindex = function (t, k, v)
		if self.data[k] ~= nil then
            -- 不再允许设置为 nil
            if v ~= nil then self.data[k] = v end
			return
		end

		if is_class_self then
			return rawset(host, k, v)
		else
			return metatable.__newindex(t, k, v)
		end
	end

    setmetatable(host, { __index = __index, __newindex = __newindex })
end)

function ProviderProxy:NewProvider(init_provider_value)
    local function on_clean(provider)
        self.provider_list[provider] = nil
    end

    local provider = Provider(self.data, init_provider_value, on_clean)
    self.provider_list[provider] = provider

    return provider
end

local Providers = {
    -- [host] = ProviderProxy
}

-- 静态方法
function ProviderProxy.registry(host, keys_and_provider_init_value, compositor)
    local proxy = Providers[host] or ProviderProxy(host, keys_and_provider_init_value, compositor)
    Providers[host] = proxy

    return proxy:NewProvider(keys_and_provider_init_value)
end

return ProviderProxy