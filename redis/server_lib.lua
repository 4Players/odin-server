#!lua name=odinserver

---Links a canonical room id to a server instance
---@param key          string  Key to the `room::{[room-id]}::server` entry.
---@param server-id    string  The id of the server.
---@param instance-id  string  The id of the instance.
---@param timeout      number  The timeout for the link in seconds.
local function server_link_room(keys, args)
    local key = keys[1]
    local server_id = args[1]
    local instance_id = args[2]
    local timeout = args[3]
    local value = redis.call('HGET', key, 'id')
    if value == false then
        redis.call('HSET', key, 'id', server_id, 'instance-id', instance_id)
    elseif value == server_id then
        redis.call('HSET', key, 'instance-id', instance_id)
    else
        return 0
    end
    redis.call('EXPIRE', key, timeout)
    redis.call('TYPE', key)
    return 1
end

---Removes a previously made link between a canonical room id and a server instance
---@param key          string  Key to the `room::{[room-id]}::server` entry.
---@param server-id    string  The id of the server.
---@param instance-id  string  The id of the instance.
local function server_unlink_room(keys, args)
    local key = keys[1]
    local server_id = args[1]
    local instance_id = args[2]
    local values = redis.call('HMGET', key, 'id', 'instance-id')
    if values[1] == server_id and values[2] == instance_id then
        return redis.call('DEL', key)
    else
        return 0
    end
end

redis.register_function{
    function_name='server_link_room',
    callback=server_link_room,
    description='Creates a link between a canonical room id and a server instance'
}

redis.register_function{
    function_name='server_unlink_room',
    callback=server_unlink_room,
    description='Removes a link between a canonical room id and a server instance'
}
