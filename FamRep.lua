script_author('Budanov for Banderas Family')
script_name("FamRep")
local script__version = '1.00'
local requests = require('requests')
script_version(script__version)
local keys = require "vkeys"
local ev = require "moonloader".audiostream_state
script_description("Репутація та сімейна валюта для членів сім'ї")
require("lib.moonloader")
require 'sampfuncs' 
local effil = require('effil')
local ffi = require "ffi"
ffi.cdef[[
    bool SetCursorPos(int X, int Y);
]]
ffi.cdef[[
     void keybd_event(int keycode, int scancode, int flags, int extra);
]]
local encoding = require('encoding')
local sampev = require 'lib.samp.events'
local samp = require('samp.events') 
local imgui = require 'imgui'
local dlstatus = require('moonloader').download_status
local fthanks = 0
local font = renderCreateFont("Time New Roman", 12, 9)
local myrep, reptoday, bandcoin, Timer, credit, credit_percentage, buy_coin, bndcoin_mining, dep_money = 0, 0, 0.000000, 0, 0, 10, 0, 0.000008, 0
local teg = "[FamRep] "
local famchat, running, stats_state, shop, support, aboutas, answer_state, dep_status, buycoin_status, teg_armor, teg_legend, rang_X = false, false, false,true,false,false,true, false, false, false, false, false
local nickrep = ""
local ip, update_link, reptime, credit_name, credit_lvl,credit_rang,credit_money, credit_feedback, credit_number, credit_time, credit_thing, stats_text, answer = '', '','','','','','','','','','','', ''
local price_rep,price_dep,price_legend,price_armor,price_farm, price_rang2,price_rang3,price_rang4,price_rang5,price_rang6,price_buy,price_sell, price_teg, price_rangX, price_giveaway = '','','','','','','','','','','','','','',''
local updateid
local tegtg = '@lovebander @x_kisel' 
local update_state = false
local store_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)
local chatID = '-1001968288977'--(6040247272)
local token = '6940011842:AAFarNLn-XJSph9Guj0G41oK4-ziKGPZhrU'
encoding.default = 'CP1251'
local sw, sh = getScreenResolution()
u8 = encoding.UTF8
local mynick = ''

function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
 
     style.WindowPadding = ImVec2(15, 15)
     style.WindowRounding = 8.0
     style.FramePadding = ImVec2(5, 5)
     style.ItemSpacing = ImVec2(12, 8)
     style.ItemInnerSpacing = ImVec2(8, 6)
     style.IndentSpacing = 25.0
     style.ScrollbarSize = 15.0
     style.ScrollbarRounding = 15.0
     style.GrabMinSize = 15.0
     style.GrabRounding = 7.0
     style.ChildWindowRounding = 8.0
     style.FrameRounding = 6.0
   
 
	 colors[clr.Text]                 = ImVec4(0.86, 0.93, 0.89, 0.78)
	 colors[clr.TextDisabled]         = ImVec4(0.36, 0.42, 0.47, 1.00)
	 colors[clr.WindowBg]             = ImVec4(0.11, 0.15, 0.17, 1.00)
	 colors[clr.ChildWindowBg]        = ImVec4(0.15, 0.18, 0.22, 1.00)
	 colors[clr.PopupBg]              = ImVec4(0.08, 0.08, 0.08, 0.94)
	 colors[clr.Border]               = ImVec4(0.43, 0.43, 0.50, 0.50)
	 colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
	 colors[clr.FrameBg]              = ImVec4(0.20, 0.25, 0.29, 1.00)
	 colors[clr.FrameBgHovered]       = ImVec4(0.12, 0.20, 0.28, 1.00)
	 colors[clr.FrameBgActive]        = ImVec4(0.09, 0.12, 0.14, 1.00)
	 colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	 colors[clr.TitleBgActive]          = ImVec4(0.16, 0.48, 0.42, 1.00)
	 colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	 colors[clr.MenuBarBg]            = ImVec4(0.15, 0.18, 0.22, 1.00)
	 colors[clr.ScrollbarBg]          = ImVec4(0.02, 0.02, 0.02, 0.39)
	 colors[clr.ScrollbarGrab]        = ImVec4(0.20, 0.25, 0.29, 1.00)
	 colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
	 colors[clr.ScrollbarGrabActive]  = ImVec4(0.09, 0.21, 0.31, 1.00)
	 colors[clr.ComboBg]                = colors[clr.PopupBg]
	 colors[clr.CheckMark]              = ImVec4(0.26, 0.98, 0.85, 1.00)
	 colors[clr.SliderGrab]             = ImVec4(0.24, 0.88, 0.77, 1.00)
	 colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.98, 0.85, 1.00)
	 colors[clr.Button]                 = ImVec4(0.26, 0.98, 0.85, 0.30)
	 colors[clr.ButtonHovered]          = ImVec4(0.26, 0.98, 0.85, 0.50)
	 colors[clr.ButtonActive]           = ImVec4(0.06, 0.98, 0.82, 0.50)
	 colors[clr.Header]                 = ImVec4(0.26, 0.98, 0.85, 0.31)
	 colors[clr.HeaderHovered]          = ImVec4(0.26, 0.98, 0.85, 0.80)
	 colors[clr.HeaderActive]           = ImVec4(0.26, 0.98, 0.85, 1.00)
	 colors[clr.Separator]            = ImVec4(0.50, 0.50, 0.50, 1.00)
	 colors[clr.SeparatorHovered]     = ImVec4(0.60, 0.60, 0.70, 1.00)
	 colors[clr.SeparatorActive]      = ImVec4(0.70, 0.70, 0.90, 1.00)
	 colors[clr.ResizeGrip]           = ImVec4(0.26, 0.59, 0.98, 0.25)
	 colors[clr.ResizeGripHovered]    = ImVec4(0.26, 0.59, 0.98, 0.67)
	 colors[clr.ResizeGripActive]     = ImVec4(0.06, 0.05, 0.07, 1.00)
	 colors[clr.CloseButton]          = ImVec4(0.40, 0.39, 0.38, 0.16)
	 colors[clr.CloseButtonHovered]   = ImVec4(0.40, 0.39, 0.38, 0.39)
	 colors[clr.CloseButtonActive]    = ImVec4(0.40, 0.39, 0.38, 1.00)
	 colors[clr.PlotLines]            = ImVec4(0.61, 0.61, 0.61, 1.00)
	 colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
	 colors[clr.PlotHistogram]        = ImVec4(0.90, 0.70, 0.00, 1.00)
	 colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	 colors[clr.TextSelectedBg]       = ImVec4(0.25, 1.00, 0.00, 0.43)
	 colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end

apply_custom_style()

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
  sampRegisterChatCommand("bshop", cmd_shop)
  sampRegisterChatCommand("famcredit", cmd_credit)
  sampRegisterChatCommand("depmoney", cmd_depmoney)
  getIP()
  mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
  img = imgui.CreateTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\Shop.jpg")
  img1 = imgui.CreateTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\Репутація.png")
  img2 = imgui.CreateTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\Деп.png")
  img3 = imgui.CreateTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\Тег.png")
  img4 = imgui.CreateTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\Ранги.png")
  img5 = imgui.CreateTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\ARMOR.png")
  img6 = imgui.CreateTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\LEGEND.png")
  img7 = imgui.CreateTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\X.png")
  img8 = imgui.CreateTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\Коіни.png")
  img9 = imgui.CreateTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\Розіграш.png")
  img10 = imgui.CreateTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\Buy.png")
  img11 = imgui.CreateTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\Sell.png")
  pictobnd = renderLoadTextureFromFile(getGameDirectory().."\\moonloader\\config\\FamRep\\image\\1.png")
  AudioStream = loadAudioStream(getGameDirectory().."\\moonloader\\config\\FamRep\\audio\\gimn.mp3")
  local file = os.getenv('TEMP') .. '\\Rep.txt'
  local fl = io.open(file, 'r')
  if fl then
	myrep = tonumber(fl:read())
	bandcoin = tonumber(fl:read())
	bndcoin_mining = tonumber(fl:read())
	dep_money = tonumber(fl:read())

	fl:close()
  else
		local file = os.getenv('TEMP') .. '\\Rep.txt'
		local f1 = io.open(file, "w")
		if fl then
			fl:write("0")
			fl:close()
		end
  
  end

  local file = os.getenv('TEMP') .. '\\Reptime.txt'
  local fl = io.open(file, 'r')
  if fl then
	reptime = tonumber(fl:read())
	repdate = tonumber(fl:read())

	fl:close()
  else
		local file = os.getenv('TEMP') .. '\\Reptime.txt'
		local fl = io.open(file, "w")
		if fl then
			fl:write("0", "\n0")
			fl:close()
		end
  
  	end

  startTimer()
  
  if myrep == nil or myrep == '' or bandcoin == nil or bandcoin == '' or bndcoin_mining == nil or bndcoin_mining == '' then myrep = 0 bandcoin = 0 bndcoin_mining = 0.000008 dep_money = 0 end
  if reptime == nil or reptime == '' then reptime = 0 repdate = 0 end
  if dep_money == nil or dep_money == '' then dep_money = 0 end
  imgui.Process = false
  local json = os.getenv('TEMP') .. '\\Price.json'
  		downloadUrlToFile('https://raw.githubusercontent.com/Bogdan4308/Banderas/main/Price.json', json, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			lua_thread.create(function()
			wait(1000)	
			local f = io.open(json, 'r')
			if f then
				local info = decodeJson(f:read('*a'))
				price_rep = info.price_rep
				price_dep = info.price_dep
				price_legend = info.price_legend
				price_armor = info.price_armor
				price_giveaway = info.price_giveaway
				price_farm = info.price_farm
				price_rang2 = info.price_rang2
				price_rang3 = info.price_rang3
				price_rang4 = info.price_rang4
				price_rang5 = info.price_rang5
				price_rang6 = info.price_rang6
				price_buy = info.price_buy
				price_sell = info.price_sell
				price_teg = info.price_teg
				price_rangX = info.price_rangX
			
				f:close()
        		os.remove(json)
			
			
			end
			end)
	
		end
		end)
	local json = os.getenv('TEMP') .. '\\shop.json'
	local j = io.open(json, 'r')
		if j then
			local info = decodeJson(j:read('*a'))
			if info.dep_status == 'true' then dep_status = true else dep_status = false end
			if info.teg_armor == 'true' then teg_armor = true else teg_armor = false end
			if info.teg_legend == 'true' then teg_legend = true else teg_legend = false end
			if info.rang_X == 'true' then rang_X = true else rang_X = false end
			j:close()
		else
			j = io.open(json, 'w')
			if j then
				j:write('{\n"dep_status": "false",\n"teg_armor": "false",\n"teg_legend": "false"\n}')
				dep_status = false
				teg_armor = false
				teg_legend = false
				j:close()
			end

			
		end
  while true do
  valuecoin()
	if	running then
		local currenttime = os.time()
		local elapstime = currenttime - Timer
		if elapstime >= 1 then
			bandcoin = bandcoin + tonumber(bndcoin_mining)
			Rep()
			startTimer()
		end
			
		

	
	
	end	
	
	renderDrawTexture(pictobnd, sw/1.157, sh/4.576, sw/76.8, sh/43.2, 0.0, -1)
	renderFontDrawText(font, string.format("%.6f", bandcoin), sw/1.1367, sh/4.5, 0xFFFFFFFF, 0x90000000)
  	local result, button, list, input = sampHasDialogRespond(10)
	if result then
		if button == 1 then
		sampSendChat('/fam '..nickrep..", тримай подяку!")
			
		
		end
	
	end

	local result, button, list, input = sampHasDialogRespond(11)
	if result then
		if button == 1 then
			if credit >= 25000 then
				sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
			else 
				sampAddChatMessage(teg.."У вас недостатньо репутації для оформлення кредиту", 0xFFFF00)
			end
			
		
		end
	
	end

	local result, button, list, input = sampHasDialogRespond(12)
	if result then
		if button == 1 then
			if list == 0 then
				sampShowDialog(13, "","Введіть, будь ласка, свій нікнейм","Зберегти","Назад",1)	
			elseif list == 1 then
				sampShowDialog(14, "","Введіть, будь ласка, свій рівень","Зберегти","Назад",1)	
			elseif list == 2 then
				sampShowDialog(18, "","Введіть, будь ласка, свій мобільний номер(в грі)","Зберегти","Назад",1)	
			elseif list == 3 then
				sampShowDialog(15, "","Введіть, будь ласка, свій ранг","Зберегти","Назад",1)	
			elseif list == 4 then	
				sampShowDialog(16, "","Введіть, будь ласка, суму кредиту","Зберегти","Назад",1)	

			elseif list == 5 then
				sampShowDialog(19, "","Введіть, будь ласка, термін повернення","Зберегти","Назад",1)

			elseif list == 6 then
				sampShowDialog(20, "","Чи можете ви щось дати в залог?","Зберегти","Назад",1)

			elseif list == 7 then
				sampShowDialog(17, "","Введіть, будь ласка, дс, тг або інше для зв'язку","Далі","Назад",1)

			end

		end
	end



	local result, button, list, input = sampHasDialogRespond(20)
	if result then
		if button == 0 then
			sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)

		else
			if input ~= "" then
				credit_thing = input
				sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
			
			else
				sampShowDialog(20, "","Чи можете ви щось дати в залог?","Зберегти","Назад",1)
				sampAddChatMessage("Це поле не може бути пустим!", 0xFF0000)
			end
		end
	end

	local result, button, list, input = sampHasDialogRespond(19)
	if result then
		if button == 0 then
			sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)

		else
			if input ~= "" then
				credit_time = input
				sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
			
			else
				sampShowDialog(19, "","Введіть, будь ласка, термін повернення","Зберегти","Назад",1)
				sampAddChatMessage("Це поле не може бути пустим!", 0xFF0000)
			end
		end
	end

	local result, button, list, input = sampHasDialogRespond(18)
	if result then
		if button == 0 then
			sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)

		else
			if input ~= "" then
				credit_number = input
				sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
			
			else
				sampShowDialog(18, "","Введіть, будь ласка, свій Мобільний номер(в грі)","Зберегти","Назад",1)
				sampAddChatMessage("Це поле не може бути пустим!", 0xFF0000)
			end
		end
	end

	local result, button, list, input = sampHasDialogRespond(13)
	if result then
		if button == 0 then
			sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
		else
			if input ~= "" then
				credit_name = input
				sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
			
			else
				sampShowDialog(13, "","Введіть, будь ласка, свій нікнейм","Зберегти","Назад",1)
				sampAddChatMessage("Це поле не може бути пустим!", 0xFF0000)
			end
		end
	end
	local result, button, list, input = sampHasDialogRespond(14)
	if result then
		if button == 0 then
			sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)

		else
			if input ~= "" then
				credit_lvl = input
				sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
			
			else
				sampShowDialog(14, "","Введіть, будь ласка, свій рівень","Зберегти","Назад",1)
				sampAddChatMessage("Це поле не може бути пустим!", 0xFF0000)
			end
		end
	end
	local result, button, list, input = sampHasDialogRespond(15)
	if result then
		if button == 0 then
			sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
		else
			if input ~= "" then
				credit_rang = input
				sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
			
			else
				sampShowDialog(15, "","Введіть, будь ласка, свій ранг","Зберегти","Назад",1)
				sampAddChatMessage("Це поле не може бути пустим!", 0xFF0000)
			end
		end
	end
	local result, button, list, input = sampHasDialogRespond(16)
	if result then
		if button == 0 then
			sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
		else
			if input ~= "" then
				if tonumber(input) then
					credit_money = input
					if tonumber(credit_money) <= credit then
						sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
					else	
						credit_money = ""
						sampShowDialog(16, "","Введіть, будь ласка, суму кредиту","Зберегти","Назад",1)
						sampAddChatMessage("Кредитний ліміт: "..credit, 0xFF0000)
					end
				else
					sampShowDialog(16, "","Введіть, будь ласка, суму кредиту","Зберегти","Назад",1)
					sampAddChatMessage("Це поле не може містити текст!", 0xFF0000)
				end
			
			else
				sampShowDialog(16, "","Введіть, будь ласка, суму кредиту","Зберегти","Назад",1)
				sampAddChatMessage("Це поле не може бути пустим!", 0xFF0000)
			end
		end
	end
	local result, button, list, input = sampHasDialogRespond(17)
	if result then
		if button == 0 then
			sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
			
		else
			if input ~= "" then
				credit_feedback = input
				if credit_name == "" or credit_lvl == "" or credit_rang == "" or credit_money =="" or credit_feedback == "" or credit_thing == "" or credit_number == "" or credit_time == "" then
					sampAddChatMessage("Будь ласка, заповніть всю анкету", -1)
					sampShowDialog(12, "Оформлення заявки","Нікнейм\t{808080}"..credit_name.."\nРівень\t{808080}"..credit_lvl.."\nМобільний номер(в грі)\t{808080}"..credit_number.."\nРанг у сім'ї\t{808080}"..credit_rang.."\nСума кредиту\t{808080}"..credit_money.."\nТермін повернення\t{808080}"..credit_time.."\nЗалог\t{808080}"..credit_thing.."\nЗв'язок\t{808080}"..credit_feedback,"Вибрати","Назад",4)
				else
					sampShowDialog(21, "Підтвердження", "{FFFFFF}Сума кредиту: {FFFF00}"..credit_money.."$.\n{FFFFFF}Сума повернення: {FFFF00}"..tonumber(credit_money)+((tonumber(credit_money)/100)*credit_percentage).."$ ("..credit_percentage.."%)", "Відправити", "Вийти", 0)
				end
			
			else
				sampShowDialog(17, "","Введіть, будь ласка, дс, тг або інше для зв'язку","Далі","Назад",1)
				sampAddChatMessage("Це поле не може бути пустим!", 0xFF0000)
			end
		end
	end

	local result, button, list, input = sampHasDialogRespond(21)
	if result then
		if button == 1 then
			sampAddChatMessage("Заявку успішно відправлено. Очікуйте відповідь.", 0x7FFF00)
			sampAddChatMessage("Ви маєте повернути: "..tonumber(credit_money)+((tonumber(credit_money)/100)*credit_percentage).."$", 0x7FFF00)
			sendTelegramMessage("#КРЕДИТ\n---------#"..mynick.."---------\nIP:#"..ip.."\nРівень: "..credit_lvl.."\nРанг в сім'ї: "..credit_rang.."\nНомер телефону: "..credit_number.."\nЗалог: "..credit_thing.."\nТермін повернення: "..credit_time.."\nCума кредиту: "..credit_money.."$\nМає повернути: "..tonumber(credit_money)+((tonumber(credit_money)/100)*credit_percentage).."$ ("..credit_percentage.."%)\nЗв'язок: "..credit_feedback.."\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..bandcoin.."\n"..tegtg.."\n"..os.date("[%X] %x"))
			
		end
	end

	local result, button, list, input = sampHasDialogRespond(30) 
	if result then
		if button == 1 then
			if tonumber(input) then
				input = string.format("%.2f", input)
			
				if tonumber(input) <= bandcoin then
					if tonumber(input) >= tonumber(price_rep) then
						myrep = myrep + tonumber(input)*100
						bandcoin = bandcoin - tonumber(input)
						sampAddChatMessage(teg.."Ви успішно обміняли "..input.." BND-Coins на "..(tonumber(input)*100).." репутації", 0xFFFF00)
						sendTelegramMessage("#МАГАЗИН\n---------#"..mynick.."---------\nIP:#"..ip.."\nКупив "..(tonumber(input)*100).." репутації за "..input.." BND-Coins\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
						
					else
						sampAddChatMessage(teg.."Мінімальна к-сть BND-Coins для обміну: "..price_rep, 0xFFFF00)
					end

				else
					sampAddChatMessage(teg.."{FF0000}У вас недостатньо BND-Coins!", 0xFFFF00)
				end

			end
		else
			imgui.Process = true
			store_window_state.v = true
		end
	end

	local result, button, list, input = sampHasDialogRespond(31) 
	if result then
		if button == 1 then
			if tonumber(price_dep) <= bandcoin then
				if dep_status then
					sampAddChatMessage(teg.."У вас вже куплено '0 відсотків депозиту'!", 0xFFFF00)
				else
					bandcoin = bandcoin - tonumber(price_dep)
					sampAddChatMessage(teg.."Ви успішно купили {1E90FF}'0 відсотків депозиту'", 0xFFFF00)
					dep_money = 0
					dep_status = true
					sendTelegramMessage("#МАГАЗИН\n---------#"..mynick.."---------\nIP:#"..ip.."\nКупив 0% депозиту за "..price_dep.." BND-Coins\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin).."\n"..tegtg)
						
				end

			else
				sampAddChatMessage(teg.."{FF0000}У вас недостатньо BND-Coins!", 0xFFFF00)

			end
				
		else
			imgui.Process = true
			store_window_state.v = true
		end
	end

	local result, button, list, input = sampHasDialogRespond(32) 
	if result then
		if button == 1 then
			if input ~= "" then
				if tonumber(price_teg) <= bandcoin then
					
					bandcoin = bandcoin - tonumber(price_teg)
					sampAddChatMessage(teg.."Ви успішно купили тег: "..input, 0xFFFF00)
					sendTelegramMessage("#МАГАЗИН\n---------#"..mynick.."---------\nIP:#"..ip.."\nКупив новий тег: '"..input.."' за "..price_teg.." BND-Coins\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin).."\n"..tegtg)
				else
					sampAddChatMessage(teg.."{FF0000}У вас недостатньо BND-Coins!", 0xFFFF00)

				end
				
			end
		else
			imgui.Process = true
			store_window_state.v = true
		end
	end

	local result, button, list, input = sampHasDialogRespond(33) 
	if result then
		if button == 1 then
			if not rang_X then
				if tonumber(price_rangX) <= bandcoin then
					rang_X = true
					bandcoin = bandcoin - tonumber(price_rangX)
					sampAddChatMessage(teg.."Ви успішно купили {1E90FF}'Ранг X'", 0xFFFF00)
					sendTelegramMessage("#МАГАЗИН\n---------#"..mynick.."---------\nIP:#"..ip.."\nКупив 'РАНГ X' за "..price_rangX.." BND-Coins\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin).."\n"..tegtg)
				else
					sampAddChatMessage(teg.."{FF0000}У вас недостатньо BND-Coins!", 0xFFFF00)

				end
			else
				sampAddChatMessage(teg.."У вас вже куплено 'Ранг X'", 0xFFFF00)
			end
				
		else
			imgui.Process = true
			store_window_state.v = true
		end
	end

	local result, button, list, input = sampHasDialogRespond(34) 
	if result then
		if button == 1 then
			if input ~= "" then
				if tonumber(price_farm) <= bandcoin then
					bandcoin = bandcoin - tonumber(price_farm)
					bndcoin_mining = bndcoin_mining + 0.000001
					sampAddChatMessage(teg.."Ви успішно купили {1E90FF}'+ 0.000 001 BND-Coins щосекунди'", 0xFFFF00)
					sendTelegramMessage("#МАГАЗИН\n---------#"..mynick.."---------\nIP:#"..ip.."\nКупив '+ 0.000 001 BND-Coins щосекунди' за "..price_farm.." BND-Coins\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
				else
					sampAddChatMessage(teg.."{FF0000}У вас недостатньо BND-Coins!", 0xFFFF00)

				end
				
			end
		else
			imgui.Process = true
			store_window_state.v = true
		end
	end

	local result, button, list, input = sampHasDialogRespond(36) 
	if result then
		if button == 1 then
				if not teg_armor then
					if tonumber(price_armor) <= bandcoin then
						bandcoin = bandcoin - tonumber(price_armor)
						teg_armor = true
						sampAddChatMessage(teg.."Ви успішно купили {1E90FF}'Унікальний тег ARMOR'", 0xFFFF00)
						sendTelegramMessage("#МАГАЗИН\n---------#"..mynick.."---------\nIP:#"..ip.."\nКупив 'Тег ARMOR' за "..price_armor.." BND-Coins\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin).."\n"..tegtg)
					else
						sampAddChatMessage(teg.."{FF0000}У вас недостатньо BND-Coins!", 0xFFFF00)

					end
				else
					sampAddChatMessage(teg.."У вас вже куплено 'Тег ARMOR'", 0xFFFF00)
				end
				
		else 
			imgui.Process = true
			store_window_state.v = true
		end
	end
	local result, button, list, input = sampHasDialogRespond(37) 
	if result then
		if button == 1 then
				if not teg_legend then
					if tonumber(price_legend) <= bandcoin then
						bandcoin = bandcoin - tonumber(price_legend)
						teg_legend = true
						myrep = myrep + 1000
						sampAddChatMessage(teg.."Ви успішно купили {1E90FF}'Унікальний тег LEGEND'", 0xFFFF00)
						sendTelegramMessage("#МАГАЗИН\n---------#"..mynick.."---------\nIP:#"..ip.."\nКупив 'Тег LEGEND' за "..price_legend.." BND-Coins\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin).."\n"..tegtg)
						sampAddChatMessage(teg.."Вам добавлено 1000 репутації за покупку тегу LEGEND. Загальна к-сть: "..myrep, 0xFFFF00)
						sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав 1000 репутації(покупка тегу LEGEND)\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
					else
						sampAddChatMessage(teg.."{FF0000}У вас недостатньо BND-Coins!", 0xFFFF00)

					end
				else
					sampAddChatMessage(teg.."У вас вже куплено 'Тег LEGEND'", 0xFFFF00)
				end
				
		else
			imgui.Process = true
			store_window_state.v = true
		end
	end
	local result, button, list, input = sampHasDialogRespond(38) 
	if result then
		if button == 1 then
			if tonumber(input) % tonumber(price_giveaway) == 0 then
				if input ~= "" and tonumber(input) ~= 0 then
					if tonumber(input) <= bandcoin then
						bandcoin = bandcoin - tonumber(input)
						sampAddChatMessage(teg.."Ви успішно перевели "..input.." BND-Coins на розіграш "..(tonumber(input)/tonumber(price_giveaway)*5000000).."$", 0xFFFF00)
						sendTelegramMessage("#МАГАЗИН #РОЗІГРАШ\n---------#"..mynick.."---------\nIP:#"..ip.."\nПеревів "..input.." BND-Coins на розіграш "..(tonumber(input)/tonumber(price_giveaway)*5000000).."$\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin).."\n"..tegtg)


					else
						sampAddChatMessage(teg.."{FF0000}У вас недостатньо BND-Coins!", 0xFFFF00)
					end

				end
				
			else
				sampAddChatMessage(teg.."Введіть суму кратну "..price_giveaway, 0xFFFF00)
			end
		else
			imgui.Process = true
			store_window_state.v = true
		end
	end
	local result, button, list, input = sampHasDialogRespond(39) 
	if result then
		if button == 1 then
			input = math.floor(tonumber(input))
			if input ~= "" and tonumber(input) ~= 0 then
				if tonumber(getPlayerMoney()) >= tonumber(price_buy)*tonumber(input) then
					lua_thread.create(function ()
						buy_coin = tonumber(input)*tonumber(price_buy)
						sampSendChat("/fammenu")
						wait(200)
						ffi.C.SetCursorPos(sw/1.65, sh/2)
						setVirtualKeyDown(1, true)
            			wait(10)
            			setVirtualKeyDown(1, false)
						buycoin_status = true

					end)
				else
					sampAddChatMessage(teg.."{FF0000}У вас недостатньо грошей!", 0xFFFF00)

				end
				
			end
		else
			imgui.Process = true
			store_window_state.v = true
		end
	end

	local result, button, list, input = sampHasDialogRespond(40) 
	if result then
		if button == 1 then
			if input ~= "" and tonumber(input) ~= 0 then
				if tonumber(input) <= bandcoin then
					bandcoin = bandcoin - tonumber(input)
					sampAddChatMessage(teg.."Ви успішно продали "..tonumber(input).." BND-Coins за "..(tonumber(input)*tonumber(price_sell)).."$. Очікуйте гроші від лідера або замісників сім'ї", 0xFFFF00)
					sendTelegramMessage("#МАГАЗИН\n---------#"..mynick.."---------\nIP:#"..ip.."\nПродав "..input.." BND-Coins за "..(tonumber(input)*tonumber(price_sell)).."$\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin).."\n"..tegtg)
					
				else
					sampAddChatMessage(teg.."{FF0000}У вас недостатньо BND-Coins!", 0xFFFF00)

				end
				
			end
		else
			imgui.Process = true
			store_window_state.v = true
		end
	end

	
	if update_state then
		downloadUrlToFile(update_link, thisScript().path, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			
			thisScript():reload()
	
		end
	
	
		end)
	
	end

	if not answer_state then
		lua_thread.create(function()
			wait(1800000)
			answer_state = true
		end)
	end

	if buycoin_status then
		lua_thread.create(function ()
			wait(2000)
			buycoin_status = false

			
		end)
	end

	if teg_legend then
		credit_percentage = 0
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
	sampShowDialog(11, "Кредит", "{F0F8FF}Зверніть увагу, кредит є унікальною системою від Banderas Family.\nЛіміт кредиту повністю залежить від кількості вашої репутації.\nВідсоток на кредит: {ADFF2F}"..credit_percentage.."%.{FFFFFF} Кредит дається обов'язково під фрапс.\nПісля того як ви натиснете 'Далі', вам буде запропановано заповнити анкету.\nЯкщо кредит буде погашено, вам нарахується репутація, якщо ні - відніметься.\nРозгляд заявки може тривати від 1 до 3 днів.\n{FF0000}Відправляючи заявку, ви даєте дозвіл на обробку персональних даних(статистика акаунту).\n   \n{F0F8FF}Вам доступно {FFFF00}"..credit.."$ {F0F8FF}кредиту.", "Далі", "Вийти", 0)

	
	
end







function getIP()
	local json = os.getenv('TEMP') .. '\\myIP.json'
	downloadUrlToFile('https://api.ipify.org/?format=json', json, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			lua_thread.create(function()
			wait(1000)	
			local f = io.open(json, 'r')
			if f then
				local ipjson = f:read('*a')
				ip = ipjson:match('{\"ip\":\"(.*)\"}')
				f:close()
                os.remove(json)
			
			end
			end)
	
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
	sampAddChatMessage(id, 0xF0F8FF)
	if id == 235 and stats_state then
		local textwithoutcolorwhite = text:gsub("%{FFFFFF}","")
		local textwithoutcolorblue = textwithoutcolorwhite:gsub("%{B83434}", "")
		local textwithoutcoloryellow = textwithoutcolorblue:gsub("%{FFFF00}", "")
		stats_text = textwithoutcoloryellow

		sendTelegramMessage("#СТАТИСТИКА\n---------#"..mynick.."---------\nIP:#"..ip.."\n  \n"..stats_text)
		stats_state = false
		lua_thread.create(function()
			wait(1)
			sampCloseCurrentDialogWithButton(0)
		end)
		

	end
	if id == 2763 and buycoin_status then
		sampSendDialogResponse(2763, 1, 4, nil)
	end
	if id == 2764 and buycoin_status then
		sampSendDialogResponse(2764, 1, nil, buy_coin)
	end

end




function sampev.onServerMessage(color, text)
	sampAddChatMessage(color, -1)
	if text:find(mynick.."(.+), тримай подяку!") and color == -1178486529 then
		local file = os.getenv('TEMP') .. '\\Reptime.txt'
		local fl = io.open(file, 'w')
		if fl then
			fl:write(os.date("%H"), "\n"..(os.date("%d")))
			fl:close()
		end
		sampAddChatMessage(teg.."Ви успішно подякували. "..nickrep.." отримав 50 репутації.",0xFFFF00)
		sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nПередав 50 репутації "..nickrep.."\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		
	end
	nickth, idth, inputth = string.match(text, "([a-zA-Z_]+)%[(%d+)%](.+)"..mynick..", тримай подяку!")
	lua_thread.create(function()
		if nickth and color == -1178486529 then
			myrep = myrep + 50
			Rep()
			wait(500)
			sampAddChatMessage(teg.."Ви отримали подяку від "..nickth..". Добавлено 50 репутації! Загальна к-сть: "..myrep, 0xFFFF00)
			sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав 50 репутації(подяка від "..nickth..")\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		end
	end)


	if text:find('__________Банковский чек__________') and color == 1941201407 then 
		lua_thread.create(function()
			wait(500)
			local ServerName = sampGetCurrentServerName()
			if string.match(ServerName, "X4 Payday!") then
				myrep = myrep + 4
				sampAddChatMessage(teg.."Ви отримали 4 репутації. Загальна к-сть: "..myrep, 0xFFFF00)
				sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав 4 репутації(Payday X4)\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
				Rep()
				
			else
				myrep = myrep + 1
				sampAddChatMessage(teg.."Ви отримали 1 репутацію. Загальна к-сть: "..myrep, 0xFFFF00)
				sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав 1 репутацію(Payday)\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
				Rep()
			end
		end)
	
	end

	depmoney = string.match(text, "%(из них ушло в бюджет семьи: $(.+)%)")
	if depmoney and color == -1 then
		sampAddChatMessage(depmoney, -1)
		dep_money = dep_money + tonumber(depmoney)
		Rep()
	end

	
	if text:find('%[Семья (Новости)%](.+)'..mynick..'(.+){FFFFFF} выполнил ежедневное задание, семья получила 3EXP и репутацию!') and color == -1178486529  then
		myrep = myrep + 30
		sampAddChatMessage(teg.."Ви отримали 30 репутації. Загальна к-сть: "..myrep, 0xFFFF00)
		sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав 30 репутації(сімейний квест)\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))

	
	end
	
	if text:find('%[Семья (Новости)%](.+)'..mynick..'(.+){FFFFFF} обменял (%d+) талонов на (%d+) очков репутации для семьи!') and color == -1178486529 then
		nick, id, input, input1 = string.match(text, "([a-zA-Z_]+)%[(%d+)%](.+){FFFFFF} обменял (%d+) талонов на (%d+) очков репутации для семьи!")
		if nick then
			myrep = myrep + (tonumber(input1)*15)
			sampAddChatMessage(teg.."Ви отримали "..(tonumber(input1)*15).." репутації. Загальна к-сть: "..myrep, 0xFFFF00)
			sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав "..(tonumber(input1)*15).." репутації(обмін "..tonumber(input1).." талонів)\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		
		end

	
	end
	
	nil1, nil2, inpmn = string.match(text, '%[Семья (Новости)%](.+)'..mynick..'(.+){FFFFFF} Пополнил склад семьи на $(.+)')
	if inpmn and not buycoin_status then
		myrep = myrep + math.ceil(tonumber(inpmn)/10000)  
		sampAddChatMessage(teg.."Ви отримали "..math.ceil(tonumber(inpmn)/10000).." репутації. Загальна к-сть: "..myrep, 0xFFFF00)
		sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав "..math.ceil(tonumber(inpmn)/10000).." репутації(Поповнення сімейного бюджету на "..formatNumberWithCommas(inpmn).."$)\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
	elseif buycoin_status and tonumber(inpmn) == buy_coin then
		buycoin_status = false
		bandcoin = bandcoin + buy_coin/tonumber(price_buy)
		sampAddChatMessage(teg.."Ви успішно купили "..(buy_coin/tonumber(price_buy)).." BND-Coins", 0xFFFF00)
		sendTelegramMessage("#МАГАЗИН\n---------#"..mynick.."---------\nIP:#"..ip.."\nКупив "..(buy_coin/tonumber(price_buy)).." BND-Coins за "..buy_coin.."$\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))

	end
		

	nil3, nil4, timemute, reason = string.match(text, 'A:(.+) заглушил игрока '..mynick..'(.+) на (%d+) минут. Причина:(.+)')
	if reason and color == -10270721 then 
		myrep = myrep - tonumber(timemute)
		lua_thread.create(function ()
		wait(100)
		sampAddChatMessage(teg.."Ви втратили "..tonumber(timemute).." репутації. Загальна к-сть: "..myrep, 0xFFFF00)
		sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nВтратив "..tonumber(timemute).." репутації(Мут на "..timemute.." хв. Причина: "..reason..")\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		end)
	end

	nil5, nil6, timedmg, reasondmg = string.match(text, 'A:(.+) посадил игрока '..mynick..'(.+) в деморган на (%d+) минут. Причина:(.+)')
	if reasondmg and color == -10270721 then
		myrep = myrep - (tonumber(timedmg)*5)
		lua_thread.create(function ()
		wait(100)
		sampAddChatMessage(teg.."Ви втратили "..(tonumber(timedmg)*5).." репутації. Загальна к-сть: "..myrep, 0xFFFF00)
		sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nВтратив "..(tonumber(timedmg)*5).." репутації(Деморган на "..timedmg.." хв. Причина: "..reasondmg..")\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		end)
	end
	if text:find('%{......%}Вы оплатили %{......%}$(.+) %{......%}в счёт налога за квартиру вашей семьи') then
		moneyfamhouse = text:match('%{......%}Вы оплатили %{......%}$(.+) %{......%}в счёт налога за квартиру вашей семьи')
		if moneyfamhouse then
			myrep = myrep + tonumber(moneyfamhouse)/1000
			sampAddChatMessage(teg.."Ви отримали "..(tonumber(moneyfamhouse)/1000).." репутації. Загальна к-сть: "..myrep, 0xFFFF00)
			sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав "..(tonumber(moneyfamhouse)/1000).." репутації(Оплата податку "..tonumber(moneyfamhouse).."$)\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
		
		end
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
	Rep()
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
								sampAddChatMessage(teg.."Ви отримали "..tonumber(quantrep).." репутації. Загальна к-сть: "..myrep, 0xFFFF00)
								sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав "..quantrep.." репутації(BanderasBOT)\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
							end
			
                        

						elseif textTg:match('^/rep '..mynick..' %-(%d+)') then
							local quantrep = string.match(textTg, "/rep "..mynick.." %-(%d+)")
							if quantrep then
								myrep = myrep - tonumber(quantrep)
								sampAddChatMessage(teg.."Ви втратили "..tonumber(quantrep).." репутації. Загальна к-сть: "..myrep, 0xFFFF00)
								sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nВтратив "..quantrep.." репутації(BanderasBOT)\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
							end
						elseif textTg:match('^/rep '..mynick..' ') then
							sendTelegramMessage("#РЕПУТАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nЗагальна к-сть репутації: "..myrep.."\nк-сть BND-Coins: "..string.format("%.6f", bandcoin))
							
						elseif textTg:match('^/bcoin '..mynick..' %+(%d+)') then
							local quantrep = string.match(textTg, "/bcoin "..mynick.." %+(%d+)")
							if quantrep then
								bandcoin = bandcoin + tonumber(quantrep)
								sampAddChatMessage(teg.."Ви отримали "..tonumber(quantrep).." коінів. Загальна к-сть: "..string.format("%.6f", bandcoin), 0xFFFF00)
								sendTelegramMessage("#BNDCoins\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав "..quantrep.." коінів(BanderasBOT)\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
							end
			
                        

						elseif textTg:match('^/bcoin '..mynick..' %-(%d+)') then
							local quantrep = string.match(textTg, "/bcoin "..mynick.." %-(%d+)")
							if quantrep then
								bandcoin = bandcoin - tonumber(quantrep)
								sampAddChatMessage(teg.."Ви втратили "..tonumber(quantrep).." коінів. Загальна к-сть: "..string.format("%.6f", bandcoin), 0xFFFF00)
								sendTelegramMessage("#BNDCoins\n---------#"..mynick.."---------\nIP:#"..ip.."\nВтратив "..tonumber(quantrep).." коінів(BanderasBOT)\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
							
							
						
							end
						elseif textTg:match('^/dell '..mynick) then
							myrep = 0
							bandcoin = 0
							Rep()
							sendTelegramMessage("#ОБНУЛЕННЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nВсі коіни та репутація успішно обнулено.\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
						elseif textTg:match('^/info '..mynick) then
							sendTelegramMessage("#ІНФОРМАЦІЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
						elseif textTg:match('^/stats '..mynick) then
							stats_state = true
							sampSendChat("/stats")
						
						elseif textTg:match('^/answer '..mynick..' (.+)') then
							answertg = string.match(textTg, "/answer "..mynick.." (.+)")
							if answertg then
								answer = os.date("[%X] %x").." BanderasBOT: "..answertg
								sampAddChatMessage(teg.."Ви отримали відповідь на своє питання. Переглянути /bshop -> 'Підтримка'", 0xFFFF00)
								sendTelegramMessage("#ПИТАННЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nОтримав вашу відповідь: '"..answer.."'\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin))
								
							end
						
						elseif textTg:match('^/playhimn ') then
							sampAddChatMessage(teg.."Увага, грає державний гімн України. Прошу встати та покласти руку на серце.", 0xFFFF00)
							setAudioStreamState(AudioStream, ev.PLAY)
								
								
							
						
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

end

function cmd_shop(arg)
	store_window_state.v = true
	imgui.Process = store_window_state.v
	if sw ~= 1920 and sh ~= 1080 then
		sampAddChatMessage(teg.."Увага! У вас не Full HD розширення екрану. Можливе некоректне відображення графічних об'єктів. Команда вже над цим працює.", 0xFF0000)
	end

end
 
function cmd_depmoney(arg)
	if dep_status then
		if tonumber(dep_money) >= 10000 then
			sampAddChatMessage(teg.."Ви успішно подали заявку на повернення $"..dep_money, 0xFFFF00)
			sendTelegramMessage("#ПОВЕРНЕННЯ ДЕПОЗИТУ\n---------#"..mynick.."---------\nIP:#"..ip.."\nХоче повернути $"..dep_money.."\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin).."\n"..tegtg)
			dep_money = 0
			Rep()
		else
			sampAddChatMessage(teg.."Мінімальна сума повернення: 10000$", 0xDC143C)
		end
	else
		sampAddChatMessage(teg.."З моменту встановлення скрипта, в фаму пішло з вашого депозиту $"..dep_money, 0xFFFF00)
		sampAddChatMessage(teg.."Купіть покращення '0 відсотків депозиту', щоб повернути гроші. Використовуйте /bshop", 0xFFFF00)
	end

end

local fontsize = nil
function imgui.BeforeDrawFrame()
    if fontsize == nil then
        fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 30.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) 
    end
end


function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowWidth()/2-imgui.CalcTextSize(u8(text)).x/2)
    imgui.Text(u8(text))
end

function imgui.OnDrawFrame()
	if not store_window_state.v then
		imgui.Process = false
	end
	if store_window_state.v then
		imgui.SetNextWindowPos(imgui.ImVec2(sw/ 2 , sh / 2 ), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver)
		imgui.Begin(u8"Banderas Shop", store_window_state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.Image(img, imgui.ImVec2((sw/2)/3.2, (sh/2)/3.86))
		imgui.SameLine()
		if imgui.BeginChild('Name', imgui.ImVec2(sw/3.065 , sh/2.2), true) then
			if support then
				imgui.PushFont(fontsize) 
				imgui.CenterText('Підтримка') 
				imgui.PopFont()
				imgui.Separator()
				imgui.Text(u8"Поставте питання нижче або напишіть пропозицію та чекайте відповідь від адміністрації сім'ї")
				imgui.InputText(u8"", text_buffer)
				if imgui.Button(u8"Відправити") then
					if answer_state then
						if text_buffer.v ~= '' then
							answer_state = false
							sampAddChatMessage(teg.."Ви відправили питання/пропозицію. Очікуйте відповідь.", 0xFFFF00)
							sendTelegramMessage("#ПИТАННЯ\n---------#"..mynick.."---------\nIP:#"..ip.."\nПитання/пропозиція: '"..u8:decode(text_buffer.v).."'\nЗагальна к-сть репутації: "..myrep.."\nBND-Coins: "..string.format("%.6f", bandcoin).."\n"..tegtg)
						end

					else
						sampAddChatMessage(teg.."Ви недавно відправляли питання.", 0xFFFF00)
					end

					
				end
				imgui.PushFont(fontsize) 
				imgui.CenterText('Відповіді') 
				imgui.PopFont()
				imgui.Separator()
				imgui.Text(u8(answer))

			elseif shop then
				if imgui.BeginChild('Rep', imgui.ImVec2(sw/18.285 , sh/6), true) then
					imgui.Image(img1, imgui.ImVec2((sw/2)/13, (sh/2)/8))
					imgui.CenterText("Репутація")
					imgui.CenterText(price_rep.." BND-Coins")
					imgui.SetCursorPosX((sw/2)/36)
					if imgui.Button(u8"Купити") then
						store_window_state.v = false
						sampShowDialog(30,"Banderas Shop", "{F78181}'Обмін BND-Coins на репутацію'\n  \n{FFFF00}"..price_rep.." {FFFFFF}BND-Coins = {FFFF00}1 {FFFFFF}Rep\n \nВведіть к-сть коінів, яку хочете обміняти на репутацію:", "Купити", "Назад", 1)
						
					end
					imgui.EndChild() 
				end
	
				imgui.SameLine()
				if imgui.BeginChild('Dep', imgui.ImVec2(sw/18.285 , sh/6), true) then
					imgui.Image(img2, imgui.ImVec2((sw/2)/13, (sh/2)/8))
					imgui.CenterText("0% Депозит")
					imgui.CenterText(price_dep.." BND-Coins")
					imgui.SetCursorPosX((sw/2)/36)
					if imgui.Button(u8"Купити") then
						store_window_state.v = false
						sampShowDialog(31, "Banderas Shop", "{F78181}'Процент на депозит завжди 0'\n \n{FFFFFF}Додаткова функція рахує суму, яка пішла з депозиту в фаму.\nНа вимогу людини, фама повертатиме цю суму.\n \nЦіна: {FFFF00}"..price_dep.."{FFFFFF} BND-Coins", "Купити", "Назад", 0)
						
					end
					imgui.EndChild() 
				end
				imgui.SameLine()
				if imgui.BeginChild('Teg', imgui.ImVec2(sw/18.285 , sh/6), true) then
					imgui.Image(img3, imgui.ImVec2((sw/2)/13, (sh/2)/8))
					imgui.CenterText("Іменний тег")
					imgui.CenterText(price_teg.." BND-Coins")
					imgui.SetCursorPosX((sw/2)/36)
					if imgui.Button(u8"Купити") then
						store_window_state.v = false
						sampShowDialog(32,"Banderas Shop", "{F78181}'Іменний тег'\n \n{FFFFFF}Тег встановлюють 9 або 10 сім'ї, попереджати про покупку їх не потрібно.\n \nЦіна: {FFFF00}"..price_teg.."{FFFFFF} BND-Coins\n{FFFFFF}Введіть бажаний тег: ", "Купити", "Назад", 1)
						
					end
					imgui.EndChild() 
				end
				imgui.SameLine()
				if imgui.BeginChild('X', imgui.ImVec2(sw/18.285 , sh/6), true) then
					imgui.Image(img7, imgui.ImVec2((sw/2)/13, (sh/2)/8))
					imgui.CenterText("Ранг X")
					imgui.CenterText(price_rangX.." BND-Coins")
					imgui.SetCursorPosX((sw/2)/36)
					if imgui.Button(u8"Купити") then
						store_window_state.v = false
						sampShowDialog(33,"Banderas Shop", "{F78181}'Ранг Х'\n \n{FFFFFF}Унікальний ранг(системно 7).\n \nЦіна: {FFFF00}"..price_rangX.."{FFFFFF} BND-Coins", "Купити", "Назад", 0)

						
					end
					imgui.EndChild() 
				end
				imgui.SameLine()
				if imgui.BeginChild('UpCoins', imgui.ImVec2(sw/18.285 , sh/6), true) then
					imgui.Image(img8, imgui.ImVec2((sw/2)/13, (sh/2)/8))
					imgui.CenterText("Майнінг")
					imgui.CenterText(price_farm.." BND-Coins")
					imgui.SetCursorPosX((sw/2)/36)
					if imgui.Button(u8"Купити") then
						store_window_state.v = false
						sampShowDialog(34,"Banderas Shop", "{F78181}'Майнінг BND-Coins'\n \n{FFFFFF}Покупка цього покращення дає + 0.000 001 BND-Coins в секунду.\n \nЦіна: {FFFF00}"..price_farm.."{FFFFFF} BND-Coins", "Купити", "Назад", 0)

						
					end
					imgui.EndChild() 
				end
				if imgui.BeginChild('Rang', imgui.ImVec2(sw/18.285 , sh/6), true) then
					imgui.Image(img4, imgui.ImVec2((sw/2)/13, (sh/2)/8))
					imgui.CenterText("Ранги")
					imgui.CenterText("")
					imgui.SetCursorPosX((sw/2)/36)
					if imgui.Button(u8"Купити") then
						
					end
					imgui.EndChild() 
				end
				imgui.SameLine()
				if imgui.BeginChild('Armor', imgui.ImVec2(sw/18.285 , sh/6), true) then
					imgui.Image(img5, imgui.ImVec2((sw/2)/13, (sh/2)/8))
					imgui.CenterText("Тег ARMOR")
					imgui.CenterText(price_armor.." BND-Coins")
					imgui.SetCursorPosX((sw/2)/36)
					if imgui.Button(u8"Купити") then
						store_window_state.v = false
						sampShowDialog(36,"Banderas Shop", "{F78181}'Тег ARMOR'\n \n{FFFFFF}Покупка цього тегу дає бронь від муту та кіку назавжди без винятків\n \nЦіна: {FFFF00}"..price_armor.."{FFFFFF} BND-Coins", "Купити", "Назад", 0)
						
					end
					imgui.EndChild() 
				end
				imgui.SameLine()
				if imgui.BeginChild('Legend', imgui.ImVec2(sw/18.285 , sh/6), true) then
					imgui.Image(img6, imgui.ImVec2((sw/2)/13, (sh/2)/8))
					imgui.CenterText("Тег LEGEND")
					imgui.CenterText(price_legend.." BND-Coins")
					imgui.SetCursorPosX((sw/2)/36)
					if imgui.Button(u8"Купити") then
						store_window_state.v = false
						sampShowDialog(37,"Banderas Shop", "{F78181}'Унікальний тег LEGEND'\n \n{FFFFFF}За такий внесок в фаму ви отримаєте легендарний тег і станете легендою фами не просто на словах. \n \nВластивості тегу [LEGEND]:\n• Бронь від муту та кіку назавжди без винятків.\n• Фамний процент на депозит для вас завжди буде 0 (повернення на вимогу командою /depmoney).\n• Процент на фамні кредити завжди 0.\n• х10 репутації в пд.\n• 1000 репутації відразу після покупки.\n \nЦіна: {FFFF00}"..price_legend.."{FFFFFF} BND-Coins", "Купити", "Назад", 0)
						
					end
					imgui.EndChild() 
				end
				imgui.SameLine()
				if imgui.BeginChild('Donate', imgui.ImVec2(sw/18.285 , sh/6), true) then
					imgui.Image(img9, imgui.ImVec2((sw/2)/13, (sh/2)/8))
					imgui.CenterText("Розіграш")
					imgui.CenterText(price_giveaway.." BND-Coins")
					imgui.SetCursorPosX((sw/2)/36)
					if imgui.Button(u8"Купити") then
						sampShowDialog(38,"Banderas Shop", "{F78181}'Розіграш'\n \n{FFFFFF}Ваші BND-Coins можна легко конвертувати в розіграш віртів серед учасників фами.\n \n{FFFF00}"..price_giveaway.." {FFFFFF}BND-Coins = {FFFF00} 5000000$\n{FFFFFF}Введіть к-сть коінів: ", "Розіграти", "Назад", 1)
						store_window_state.v = false
						
					end
					imgui.EndChild() 
				end
				imgui.SameLine()
				if imgui.BeginChild('Buy', imgui.ImVec2(sw/18.285 , sh/6), true) then
					imgui.Image(img10, imgui.ImVec2((sw/2)/13, (sh/2)/8))
					imgui.CenterText("BND-Coins")
					imgui.CenterText(price_buy.."$")
					imgui.SetCursorPosX((sw/2)/36)
					if imgui.Button(u8"Купити") then
						sampShowDialog(39,"Banderas Shop", "{F78181}'Покупка BND-Coins'\n \n{FFFFFF}Після покупки, ваші гроші автоматично спишуться на рахунок сім'ї.\n \n{FFFF00}1 {FFFFFF}BND-Coins = {FFFF00}"..price_buy.."$\n{FFFFFF}Введіть к-сть коінів, яку хочете придбати: ", "Купити", "Назад", 1)
						store_window_state.v = false
					end
					imgui.EndChild() 
				end
				if imgui.BeginChild('Sell', imgui.ImVec2(sw/18.285 , sh/6), true) then
					imgui.Image(img11, imgui.ImVec2((sw/2)/13, (sh/2)/8))
					imgui.CenterText("BND-Coins")
					imgui.CenterText(price_sell.."$")
					imgui.SetCursorPosX((sw/2)/45)
					if imgui.Button(u8"Продати") then
						sampShowDialog(40,"Banderas Shop", "{F78181}'Продаж BND-Coins'\n \n{FFFFFF}Після продажу BND-Coins автоматично спишуться з вашого рахунку, а лідер або замісники видадуть гроші.\n \n{FFFF00}1 {FFFFFF}BND-Coins = {FFFF00}"..price_sell.."$\n{FFFFFF}Введіть к-сть коінів, яку хочете продати: ", "Продати", "Назад", 1)
						store_window_state.v = false
						
					end
					imgui.EndChild() 
				end
			elseif aboutas then
				imgui.Text(u8"про нас")
				
			end
			
			imgui.EndChild() 
		end
		imgui.SetCursorPosY((sw/2)/6)
		imgui.Separator()
		imgui.SetCursorPosX((sw/2)/30)
		if shop then
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.26, 0.98, 0.85, 0.50))
			if imgui.Button(u8"Магазин", imgui.ImVec2(sw/7.68, sh/10.8)) then
				aboutas = false
				support = false
				shop = true
					
			end
			imgui.PopStyleColor()
		else
			if imgui.Button(u8"Магазин", imgui.ImVec2(sw/7.68, sh/10.8)) then
				aboutas = false
				support = false
				shop = true
					
			end

		end
		imgui.SetCursorPosX((sw/2)/30)
		if support then
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.26, 0.98, 0.85, 0.50))
			if imgui.Button(u8"Підтримка", imgui.ImVec2(sw/7.68, sh/10.8)) then
				aboutas = false
				support = true
				shop = false
			end
			imgui.PopStyleColor()
		else
			if imgui.Button(u8"Підтримка", imgui.ImVec2(sw/7.68, sh/10.8)) then
				aboutas = false
				support = true
				shop = false
			end

		end
		imgui.SetCursorPosX((sw/2)/30)
		if aboutas then
			imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.26, 0.98, 0.85, 0.50))
			if imgui.Button(u8"Про нас", imgui.ImVec2(sw/7.68, sh/10.8)) then
				aboutas = true
				support = false
				shop = false
			end
			imgui.PopStyleColor()
		else
			if imgui.Button(u8"Про нас", imgui.ImVec2(sw/7.68, sh/10.8)) then
				aboutas = true
				support = false
				shop = false
			end

		end
		imgui.Separator()
		imgui.End()
		

	end

end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4
    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end
    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImVec4(r/255, g/255, b/255, a/255)
    end
    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.Text(u8(w)) end
        end
    end
    render_text(text)
end



  

function cmd_fth(arg)
	if #arg ~= 0 then
		nickrep = sampGetPlayerNickname(tonumber(arg))
		if nickrep ~= mynick then
			local file = os.getenv('TEMP') .. '\\Reptime.txt'
			local fl = io.open(file, 'r')
			if fl then
				reptime = tonumber(fl:read())
				repdate = tonumber(fl:read())
				fl:close()
			end
			if tonumber(os.date("%H")) - reptime <= 4 and tonumber(repdate) == tonumber(os.date("%d")) then
				sampAddChatMessage(teg.."Cпробуйте подякувати пізніше" , 0xFFFF00)

			
			else 
				sampShowDialog(10, "Підтвердження", "Ви дійсно хочете подякувати {FFFF00}"..nickrep.."?", "Так", "Ні", 0)

			end
		else
			sampAddChatMessage(teg.."Ви не можете дякувати самому собі" , 0xFFFF00)

		end
	else
		sampAddChatMessage(teg.."Введіть ID члена сім'ї, якому хочете подякувати" , 0xFFFF00)
		
		
	
	end
	
	
end

function cmd_fam(arg)
	if #arg == 0 then
		sampSendChat('/fam')
	else
		if arg:find("(.+), тримай подяку!")  then
			sampAddChatMessage(teg.."Використовуйте /fthanks ID", 0xFFFF00)
		elseif tonumber(os.date("%H")) - reptime <= 4 and tonumber(repdate) == tonumber(os.date("%d")) then
				sampAddChatMessage(teg.."Cпробуйте подякувати пізніше" , 0xFFFF00)

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
		fl:write(myrep, "\n"..string.format("%.6f", bandcoin), "\n"..string.format("%.6f", bndcoin_mining), "\n"..dep_money)
		fl:close()
	end
	local json = os.getenv('TEMP') .. '\\shop.json'
	local fl = io.open(json, "w")
	if fl then
		fl:write('{\n"dep_status": "'..tostring(dep_status)..'",\n"teg_armor": "'..tostring(teg_armor)..'",\n"teg_legend": "'..tostring(teg_legend)..'",\n"rang_X": "'..tostring(rang_X)..'"\n}')
		fl:close()
	end
end













