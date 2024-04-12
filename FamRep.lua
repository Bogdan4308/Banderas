script_author('Budanov for Banderas Family')
script_name("FamRep")
local script__version = '1.1'
local requests = require('requests')
script_version(script__version)
local keys = require "vkeys"
script_description("Репутація та сімейна валюта для членів сім'ї")
require("lib.moonloader")
require 'sampfuncs' 
local effil = require('effil')
local encoding = require('encoding')
local sampev = require 'lib.samp.events'
local samp = require('samp.events') 
local dlstatus = require('moonloader').download_status
local fthanks = 0
local font = renderCreateFont("Arial", 10, 13)
local myrep, reptoday, delaytimer, bandcoin, Timer = 0, 0, 0, 0.000000, 0
local teg = "[FamRep] "
local famchat, running = false, false
local nickrep = ""
local ip, update_link = '', ''
local updateid
local update_state = false
local chatID = '-1001968288977'--(6040247272)
local token = '6940011842:AAFarNLn-XJSph9Guj0G41oK4-ziKGPZhrU'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local mynick = ''

function startTimer()
	Timer = os.time()
    running = true
       
end



function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then return end
  while not isSampAvailable() do wait(100) end
  getLastUpdate()
  lua_thread.create(get_telegram_updates)
  sampRegisterChatCommand("fthanks", cmd_fth)
  sampRegisterChatCommand("fam", cmd_fam)
  sampRegisterChatCommand("myrep", cmd_rep)
  getIP()
  mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))

  local file = os.getenv('TEMP') .. '\\Rep.txt'
  local fl = io.open(file, 'r')
  if fl then
	myrep = fl:read()
	bandcoin = fl:read()
	fl:close()
  else
		local file = os.getenv('TEMP') .. '\\Rep.txt'
		local f1 = io.open(file, "w")
		if fl then
			fl:write("0")
			fl:close()
		end
  
  end
  startTimer()
  
  if myrep == nil or myrep == '' then myrep = 0 end
  while true do
  valuecoin()
	if	running then
		local currenttime = os.time()
		local elapstime = currenttime - Timer
		if elapstime >= 1 then
			bandcoin = bandcoin + 0.000004
			Rep()
			startTimer()
		end
			
		

	
	
	end
	renderFontDrawText(font, string.format("%.6f", bandcoin), 1700, 250, 0xFFFFFFFF, 0x90000000)
  local result, button, list, input = sampHasDialogRespond(10)
	if result then
		if button == 1 then
		sampSendChat('/fam [Rep '..myrep..']: '..nickrep..", тримай подяку!")
			
		
		end
	
	end
	
	if update_state then
		downloadUrlToFile(update_link, thisScript().path, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then	
			
			script:reload()
	
		end
	
	
		end)
	
	end
	
	wait(0)
  end
end

function threadHandle(runner, url, args, resolve, reject)
   local t = runner(url, args)
   local r = t:get(0)
   while not r do
      r = t:get(0)
      wait(0)
   end
   local status = t:status()
   if status == 'completed' then
      local ok, result = r[1], r[2]
      if ok then resolve(result) else reject(result) end
   elseif err then
      reject(err)
   elseif status == 'canceled' then
      reject(status)
   end
   t:cancel(0)
end

function requestRunner()
   return effil.thread(function(u, a)
      local https = require 'ssl.https'
      local ok, result = pcall(https.request, u, a)
      if ok then
         return {true, result}
      else
         return {false, result}
      end
   end)
end

function async_http_request(url, args, resolve, reject)
   local runner = requestRunner()
   if not reject then reject = function() end end
   lua_thread.create(function()
      threadHandle(runner, url, args, resolve, reject)
   end)
end

function encodeUrl(str)
   str = str:gsub(' ', '%+')
   str = str:gsub('\n', '%%0A')
   return u8:encode(str, 'CP1251')
end

function table.assign(target, def, deep)
   for k, v in pairs(def) do
       if target[k] == nil then
           if type(v) == 'table' then
               target[k] = {}
               table.assign(target[k], v)
           else  
               target[k] = v
           end
       elseif deep and type(v) == 'table' and type(target[k]) == 'table' then 
           table.assign(target[k], v, deep)
       end
   end 
   return target
end







function getIP()
	local json = os.getenv('TEMP') .. '\\myIP.json'
	downloadUrlToFile('https://api.ipify.org/?format=json', json, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then	
			local f = io.open(json, 'r')
			if f then
				local ipjson = f:read('*a')
				ip = ipjson:match('{\"ip\":\"(.*)\"}')
				f:close()
                os.remove(json)
			
			end
	
		end
	end)
	
	

end

function valuecoin()
	local file = os.getenv('TEMP') .. '\\BNDCoin.json'
	downloadUrlToFile('https://raw.githubusercontent.com/Bogdan4308/Banderas/main/BNDCoin.json', file, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then	
			local f = io.open(file, 'r')
			if f then
				local info = decodeJson(f:read('*a'))
				vlcoin = info.coinvl
				version = info.version
				update_link = info.update_link
				if tonumber(version) > tonumber(script__version) then
					
				end

				f:close()
                os.remove(file)
			
			end
	
		end
	end)
	
	

end



local effilTelegramSendMessage = effil.thread(function(text, chatID, token)
	local requests = require('requests')
	requests.post(('https://api.telegram.org/bot%s/sendMessage'):format(token), {
		params = {
			text = text;
			chat_id = chatID;
		}
	})
end)

function sampev.onShowDialog(id, st, tytle, button, canc, text)
	sampAddChatMessage(id, -1)

end




function sampev.onServerMessage(color, text)
	if text:find(mynick.."(.+), тримай подяку!") and color == -1178486529 then
		fthanks = fthanks + 1
		if fthanks > 3 then
			fthanks = 3
			
		end
		reptoday = 3 - fthanks
		local textthanks = 'подяки'
		if reptoday == 1 then
			textthanks = 'подяка'
		
		end
		if reptoday == 0 then
			textthanks = 'подяк'
		
		end
		sampAddChatMessage(teg.."Ви передали "..nickrep.." 50 репутації (на сьогодні доступно "..reptoday.." "..textthanks..")",0xFFFF00)
		sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nПередав 50 репутації "..nickrep.."\nЗагальна к-ть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		
	end
	nickth, idth, inputth = string.match(text, "([a-zA-Z_]+)%[(%d+)%](.+)"..mynick..", тримай подяку!")
	lua_thread.create(function()
		if nickth and color == -1178486529 then
			myrep = myrep + 50
			Rep()
			wait(500)
			sampAddChatMessage(teg.."Ви отримали подяку від "..nickth..". Добавлено 50 репутації! Загальна к-ть: "..myrep, 0xFFFF00)
			sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав 50 репутації(подяка від "..nickth..")\nЗагальна к-ть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		end
	end)


	if text:find('__________Банковский чек__________') and color == 1941201407 then
		lua_thread.create(function()
			wait(500)
			myrep = myrep + 1
			sampAddChatMessage(teg.."Ви отримали 1 репутацію. Загальна к-ть: "..myrep, 0xFFFF00)
			sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав 1 репутацію(Payday)\nЗагальна к-ть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
			Rep()
		end)
	
	end
	
	if text:find('[Семья (Новости)](.+)'..mynick..'(.+){FFFFFF} выполнил ежедневное задание, семья получила 3EXP и репутацию!') and color == -1178486529  then
		myrep = myrep + 30
		sampAddChatMessage(teg.."Ви отримали 30 репутації. Загальна к-ть: "..myrep, 0xFFFF00)
		sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав 30 репутації(сімейний квест)\nЗагальна к-ть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))

	
	end
	
	if text:find('[Семья (Новости)](.+)'..mynick..'(.+){FFFFFF} обменял (%d+) талонов на (%d+) очков репутации для семьи!') and color == -1178486529 then
		nick, id, input, input1 = string.match(text, "([a-zA-Z_]+)%[(%d+)%](.+){FFFFFF} обменял (%d+) талонов на (%d+) очков репутации для семьи!")
		if nick then
			myrep = myrep + (tonumber(input1)*15)
			sampAddChatMessage(teg.."Ви отримали "..(tonumber(input1)*15).." репутації. Загальна к-ть: "..myrep, 0xFFFF00)
			sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав "..(tonumber(input1)*15).." репутації(обмін "..tonumber(input1).." талонів)\nЗагальна к-ть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		
		end

	
	end
	
	nil1, nil2, inpmn = string.match(text, '[Семья (Новости)](.+)'..mynick..'(.+){FFFFFF} Пополнил склад семьи на $(.+)')
	if inpmn then
		myrep = myrep + math.ceil(tonumber(inpmn)/10000)  
		sampAddChatMessage(teg.."Ви отримали "..math.ceil(tonumber(inpmn)/10000) .." репутації. Загальна к-ть: "..myrep, 0xFFFF00)
		sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав "..math.ceil(tonumber(inpmn)/10000).." репутації(Поповнення сімейного бюджету на "..formatNumberWithCommas(inpmn).."$)\nЗагальна к-ть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		
	
	end
	

	
	
	
	
	
	



end

function formatNumberWithCommas(inpmn)
    local formattedNumber = tostring(inpmn)
    local reverseFormatted = string.reverse(formattedNumber)
    local result = ""

    for i = 1, #reverseFormatted do
        result = result .. reverseFormatted:sub(i, i)
        if i % 3 == 0 and i ~= #reverseFormatted then
            result = result .. "."
        end
    end

    return string.reverse(result)
end

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


function url_encode(text)
	local text = string.gsub(text, "([^%w-_ %.~=])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
	return string.gsub(text, " ", "+")
end

function sendTelegramMessage(text)
    effilTelegramSendMessage(url_encode(u8(text)), chatID, token)
end
 
function get_telegram_updates() 
   while not updateid do wait(1) end 
   local runner = requestRunner()
   local reject = function() end
   local args = ''
   while true do
      url = 'https://api.telegram.org/bot'..token..'/getUpdates?chat_id='..chatID..'&offset=-1' 
      threadHandle(runner, url, args, processing_telegram_messages, reject)
      wait(0)
   end
end

function processing_telegram_messages(result) 
   if result then
      local proc_table = decodeJson(result)
      if proc_table.ok then
        if #proc_table.result > 0 then
            local res_table = proc_table.result[1]
            if res_table then
				if res_table.update_id ~= updateid then
                 updateid = res_table.update_id
           
					local message_from_user = res_table.message.text
					if message_from_user then
						local textTg = u8:decode(message_from_user) .. ' ' 
						if textTg:match('^/rep '..mynick..' %+(%d+)') then
							local quantrep = string.match(textTg, "/rep "..mynick.." %+(%d+)")
							if quantrep then
								myrep = myrep + tonumber(quantrep)
								sampAddChatMessage(teg.."Ви отримали "..tonumber(quantrep).." репутації. Загальна к-ть: "..myrep, 0xFFFF00)
								sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав "..quantrep.." репутації(BanderasBOT)\nЗагальна к-ть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
							end
			
                        

						elseif textTg:match('^/rep '..mynick..' %-(%d+)') then
							local quantrep = string.match(textTg, "/rep "..mynick.." %-(%d+)")
							if quantrep then
								myrep = myrep - tonumber(quantrep)
								sampAddChatMessage(teg.."Ви втратили "..tonumber(quantrep).." репутації. Загальна к-ть: "..myrep, 0xFFFF00)
								sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nВтратив "..quantrep.." репутації(BanderasBOT)\nЗагальна к-ть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
							end
						elseif textTg:match('^/rep '..mynick..' ') then
							sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nЗагальна к-ть репутації: "..myrep.."\nК-ть coins: "..string.format("%.6f", bandcoin))
							
						elseif textTg:match('^/bcoin '..mynick..' %+(%d+)') then
							local quantrep = string.match(textTg, "/bcoin "..mynick.." %+(%d+)")
							if quantrep then
								bandcoin = bandcoin + tonumber(quantrep)
								sampAddChatMessage(teg.."Ви отримали "..tonumber(quantrep).." коінів. Загальна к-ть: "..string.format("%.6f", bandcoin), 0xFFFF00)
								sendTelegramMessage("#BNDCoins\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав "..quantrep.." коінів(BanderasBOT)\nЗагальна к-ть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
							end
			
                        

						elseif textTg:match('^/bcoin '..mynick..' %-(%d+)') then
							local quantrep = string.match(textTg, "/bcoin "..mynick.." %-(%d+)")
							if quantrep then
								bandcoin = bandcoin - tonumber(quantrep)
								sampAddChatMessage(teg.."Ви втратили "..tonumber(quantrep).." коінів. Загальна к-ть: "..string.format("%.6f", bandcoin), 0xFFFF00)
								sendTelegramMessage("#BNDCoins\n---------#"..mynick.."---------\nIP:#"..ip.."\nВтратив "..tonumber(quantrep).." коінів(BanderasBOT)\nЗагальна к-ть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
							
							
						
							end
						elseif textTg:match('^/dell '..mynick) then
							myrep = 0
							bandcoin = 0
							Rep()
							sendTelegramMessage("#ОБНУЛЕННЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nВсі коіни та репутація успішно обнуленно.\nЗагальна к-ть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
						elseif textTg:match('^/info '..mynick) then
							sendTelegramMessage("#ІНФОРМАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nЗагальна к-ть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
						
						end
						
	
					end
				end
			end
			end
	   end
	end
end

function getLastUpdate()
   async_http_request('https://api.telegram.org/bot'..token..'/getUpdates?chat_id='..chatID..'&offset=-1','',function(result)
       if result then
           local proc_table = decodeJson(result)
           if proc_table.ok then
               if #proc_table.result > 0 then
                   local res_table = proc_table.result[1]
                   if res_table then
                       updateid = res_table.update_id
                   end
               else
                   updateid = 1
               end
           end
       end
   end)
end




function cmd_rep(arg)
	sampAddChatMessage(myrep, -1)
	sendTelegramMessage(mynick..'\nТЕСТ\n@lovebander @x_kisel')

end



  

function cmd_fth(arg)
	if #arg ~= 0 then
		nickrep = sampGetPlayerNickname(tonumber(arg))
		if fthanks >= 3 then
			fthanks = 3
			
		end 
		reptoday = 3 - fthanks
		if reptoday <= 0 then
			sampAddChatMessage(teg.."Всі подяки вичерпано, спробуйте пізніше" , 0xFFFF00)
			
		else 
			sampShowDialog(10, "Підтвердження", "Ви дійсно хочете подякувати {FFFF00}"..nickrep.."?", "Так", "Ні", 0)

		end
	else
		sampAddChatMessage(teg.."Введіть ID члена сім'ї, якому хочете подякувати" , 0xFFFF00)
		
	
	end
	
	
end

function cmd_fam(arg)
	if #arg == 0 then
		sampSendChat('/fam')
	else
		reptoday = 3 - fthanks
		if arg:find("(.+), тримай подяку!") and reptoday <= 0 then
			sampAddChatMessage(teg.."Всі подяки вичерпано, спробуйте пізніше" , 0xFFFF00)
			
		
		elseif tonumber(myrep) < 1000 then
			repinfam = myrep
			sampSendChat('/fam [Rep '..math.floor(repinfam)..']: '..arg)
		elseif tonumber(myrep) >= 1000 and tonumber(myrep) < 1000000 then
			repinfam = tonumber(myrep)/1000
			sampSendChat('/fam [Rep '..math.floor(repinfam)..'K]: '..arg)
		elseif tonumber(myrep) >= 1000000 then
			repinfam = tonumber(myrep)/1000000
			sampSendChat('/fam [Rep '..(math.floor(repinfam*10)/10)..'M]: '..arg)
		
		end
		
	end
end


function Rep()
	local file = os.getenv('TEMP') .. '\\Rep.txt'
	local fl = io.open(file, 'w')
	if fl then
		fl:write(myrep, "\n"..string.format("%.6f", bandcoin))
		fl:close()
	end


end













