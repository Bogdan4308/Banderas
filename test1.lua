local lanes = require("lanes").configure()
local ltn12 = require("ltn12")
local jsone = require("dkjson")
local base64 = require("base64")
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local effil = require('effil') 
local ffi = require "ffi"
ffi.cdef[[
    bool SetCursorPos(int X, int Y);
]]
ffi.cdef[[
     void keybd_event(int keycode, int scancode, int flags, int extra);
]]

local repo = "Bogdan4308/Banderas"
local file_path = "examplere.txt"
local branch = "main"
local commit_message = u8"Обновлен файл"

function shift_forward(char)
    if char >= 'a' and char <= 'z' then
        return string.char(((char:byte() - 97 + 1) % 26) + 97)
    elseif char >= 'A' and char <= 'Z' then
        return string.char(((char:byte() - 65 + 1) % 26) + 65)
    else
        return char  -- не изменяем неалфавитные символы
    end
end

function shift_backward(char)
    if char >= 'a' and char <= 'z' then
        return string.char(((char:byte() - 97 - 1) % 26) + 97)
    elseif char >= 'A' and char <= 'Z' then
        return string.char(((char:byte() - 65 - 1) % 26) + 65)
    else
        return char  -- не изменяем неалфавитные символы
    end
end

function encode(text)
    local encoded_text = {}
    for i = 1, #text do
        local char = text:sub(i, i)
        table.insert(encoded_text, shift_forward(char))
    end
    return table.concat(encoded_text)
end

function decode(text)
    local decoded_text = {}
    for i = 1, #text do
        local char = text:sub(i, i)
        table.insert(decoded_text, shift_backward(char))
    end
    return table.concat(decoded_text)
end

local api_token = decode("hiq_26pHm1cLV4DuQqwCf5JvNpObYOaNdS2ZeydV")
print(decode("hiq_26pHm1cLV4DuQqwCf5JvNpObYOaNdS2ZeydV"))

function asyncHttpRequest(method, url, args, resolve, reject)
    local request_thread = effil.thread(function (method, url, args)
       local requests = require 'requests'
       local result, response = pcall(requests.request, method, url, args)
       if result then
          response.json, response.xml = nil, nil
          return true, response
       else
          return false, response
       end
    end)(method, url, args)
 
    if not resolve then resolve = function() end end
    if not reject then reject = function() end end
    --lua_thread.create(function()
       local runner = request_thread
       while true do
          local status, err = runner:status()
          if not err then
             if status == 'completed' then
                local result, response = runner:get()
                if result then
                   resolve(response)
                else
                   reject(response)
                end
                return
             elseif status == 'canceled' then
                return reject(status)
             end
          else
             return reject(err)
          end
          wait(0)
       end
    --end)
 end

local past_COINS = 0
local past_rep = 0

function main()
    if not isSampLoaded() and not isSampfuncsLoaded() then return end 
    while not isSampAvailable() do wait(10000) end

    while true do
		wait(0)
        wait(1000)
        send()

	end


end

local r = ""
function send()
    local json = getGameDirectory()..'\\moonloader\\config\\FamRep\\info.json'
	local j = io.open(json, 'r')
	if j then
		r = j:read('*a')
		j:close()
	end
    local encoded_content = base64.encode(r)

    local sha_url = string.format("https://api.github.com/repos/%s/contents/%s?ref=%s", repo, file_path, branch)

    asyncHttpRequest("GET", sha_url, {
        headers = {
            ["Authorization"] = "token " .. api_token
        }
    }, function(response)
        if response.status_code ~= 200 then
            return
        end

        local sha_data = jsone.decode(response.text)
        local sha = sha_data.sha

        local update_data = {
            message = commit_message,
            content = encoded_content,
            sha = sha,
            branch = branch
        }

        local update_body = jsone.encode(update_data)
        local update_url = string.format("https://api.github.com/repos/%s/contents/%s", repo, file_path)

        asyncHttpRequest("PUT", update_url, {
            headers = {
                ["Authorization"] = "token " .. api_token,
                ["Content-Type"] = "application/json"
            },
            data = update_body
        }, function(response)
        end)
    end, function(error)
    end)
end
