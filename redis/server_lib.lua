#!lua name=odinserver

---Link a room-id to a room-instance on a server
local function server_link_room(keys, args)
    local key = keys[1]
    local server_id = args[1]
    local instance_id = args[2]
    local value = redis.call('HGET', key, 'id')
    if value == false then
        redis.call('HSET', key, 'id', server_id, 'instance-id', instance_id)
    elseif value == server_id then
        redis.call('HSET', key, 'instance-id', instance_id)
    else
        return 0
    end
    redis.call('EXPIRE', key, 86400)
    redis.call('TYPE', key)
    return 1
end

---Removes a previously made link between a room-id and a server instance
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

redis.register_function('server_link_room', server_link_room)
redis.register_function('server_unlink_room', server_unlink_room)
