--[[
    init.lua
    Created: 03/30/2025 16:04:06
    Description: Autogenerated script file for the map mellow_town.
]]--
-- Commonly included lua functions and data
require 'origin.common'

local mellow_town_tutor = require 'minior_jam_game.ground.mellow_town.mellow_town_tutor'
local mellow_town_tea = require 'minior_jam_game.ground.mellow_town.mellow_town_juice'

-- Package name
local mellow_town = {}

-------------------------------
-- Map Callbacks
-------------------------------
---mellow_town.Init(map)
--Engine callback function
function mellow_town.Init(map)
  COMMON.RespawnAllies()
  local partner = CH('Teammate1')
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  partner.CollisionDisabled = true

  -- Enable Miniors
  if SV.missions.FinishedMissions["RedMiniorRescue"] ~= nil then
    GROUND:Unhide("RedMinior")
  end
  if SV.missions.FinishedMissions["OrangeMiniorRescue"] ~= nil then
    GROUND:Unhide("OrangeMinior")
  end
  if SV.missions.FinishedMissions["YellowMiniorRescue"] ~= nil then
    GROUND:Unhide("YellowMinior")
  end
  if SV.missions.FinishedMissions["BlueMiniorRescue"] ~= nil then
    GROUND:Unhide("BlueMinior")
  end
  if SV.missions.FinishedMissions["GreenMiniorRescue"] ~= nil then
    GROUND:Unhide("GreenMinior")
  end
  if SV.missions.FinishedMissions["IndigoMiniorRescue"] ~= nil then
    GROUND:Unhide("IndigoMinior")
  end
  if SV.missions.FinishedMissions["VioletMiniorRescue"] ~= nil then
    GROUND:Unhide("VioletMinior")
  end
end

---mellow_town.Enter(map)
--Engine callback function
function mellow_town.Enter(map)
  local player = CH("PLAYER")
  mellow_town.Cutscene_Intro()
  GAME:FadeIn(20)

end

---mellow_town.Exit(map)
--Engine callback function
function mellow_town.Exit(map)


end

---mellow_town.Update(map)
--Engine callback function
function mellow_town.Update(map)


end

---mellow_town.GameSave(map)
--Engine callback function
function mellow_town.GameSave(map)


end

---mellow_town.GameLoad(map)
--Engine callback function
function mellow_town.GameLoad(map)
  local player = CH("PLAYER")
  GROUND:TeleportTo(CH("Teammate1"), player.Bounds.Center.X, player.Bounds.Center.Y, Direction.Up)
  GAME:FadeIn(20)

end

-------------------------------
-- Entities Callbacks
-------------------------------

function mellow_town.STORAGE_COUNTER_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()

  local state = 0
  local repeated = false

  local chara = CH("STORAGE_Kangaskhan")
  UI:SetSpeaker(chara)

  while state > -1 do
    local has_items = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount() > 0
    local has_storage = GAME:GetPlayerStorageCount() > 0

    local msg = STRINGS:Format(STRINGS.MapStrings['STORAGE_KANGA_INTRO'])
    if repeated == true then
      msg = STRINGS:Format(STRINGS.MapStrings['STORAGE_KANGA_INTRO_2'])
    end
    local storage_choices = { { STRINGS:FormatKey('MENU_STORAGE_STORE'), has_items},
    { STRINGS:FormatKey('MENU_STORAGE_TAKE_ITEM'), has_storage},
    { STRINGS:FormatKey('MENU_STORAGE_STORE_ALL'), has_items},
    { STRINGS:FormatKey("MENU_CANCEL"), true}}
    UI:BeginChoiceMenu(msg, storage_choices, 1, 4)
    UI:WaitForChoice()
    local result = UI:ChoiceResult()
    repeated = true
    if result == 1 then
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Store'], STRINGS:LocalKeyString(26)))
      UI:StorageMenu()
      UI:WaitForChoice()
    elseif result == 2 then
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Unstore'], STRINGS:LocalKeyString(26)))
      UI:WithdrawMenu()
      UI:WaitForChoice()
      elseif result == 3 then
        UI:ChoiceMenuYesNo(STRINGS:FormatKey('DLG_STORE_ALL_CONFIRM'), false);
        UI:WaitForChoice()
        if UI:ChoiceResult() then
          GAME:DepositAll()
        end
    elseif result == 4 then
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Storage_Goodbye']))
      state = -1
    end
  end
end

-- function mellow_town.ShopReroll_Action(obj, activator)
--   print(COMMON.ESSENTIALS)
--   COMMON.EndDayCycle()
-- end

function mellow_town.SHOP_LEFT_COUNTER_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  local state = 0
  local repeated = false
  local cart = {}
  local catalog = { }
  for ii = 1, #SV.mart_shop, 1 do
  local base_data = SV.mart_shop[ii]
  local item_data = { Item = RogueEssence.Dungeon.InvItem(base_data.Index, false, base_data.Amount), Price = base_data.Price }
  table.insert(catalog, item_data)
  end


  local chara = CH('MART_Kecleon_Left')
  UI:SetSpeaker(chara)

  while state > -1 do
    if state == 0 then
      local msg = STRINGS:Format(STRINGS.MapStrings['Shop_Intro'])
      if repeated == true then
        msg = STRINGS:Format(STRINGS.MapStrings['Shop_Intro_Return'])
      end
      local shop_choices = {STRINGS:Format(STRINGS.MapStrings['Shop_Option_Buy']), STRINGS:Format(STRINGS.MapStrings['Shop_Option_Sell']),
      STRINGS:FormatKey("MENU_INFO"),
      STRINGS:FormatKey("MENU_EXIT")}
      UI:BeginChoiceMenu(msg, shop_choices, 1, 4)
      UI:WaitForChoice()
      local result = UI:ChoiceResult()
      repeated = true
      if result == 1 then
        if #catalog > 0 then
          --TODO: use the enum instead of a hardcoded number
          UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Buy'], STRINGS:LocalKeyString(26)))
          state = 1
        else
          UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Buy_Empty']))
        end
      elseif result == 2 then
        local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
        if bag_count > 0 then
          --TODO: use the enum instead of a hardcoded number
          UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Sell'], STRINGS:LocalKeyString(26)))
          state = 3
        else
          UI:SetSpeakerEmotion("Angry")
          UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Bag_Empty']))
          UI:SetSpeakerEmotion("Normal")
        end
      elseif result == 3 then
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_001']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_003']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_004']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_005']))
      else
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Goodbye']))
        state = -1
      end
    elseif state == 1 then
      UI:ShopMenu(catalog)
      UI:WaitForChoice()
      local result = UI:ChoiceResult()
      if #result > 0 then
        local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
        local bag_cap = GAME:GetPlayerBagLimit()
        if bag_count == bag_cap then
          UI:SetSpeakerEmotion("Angry")
          UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Bag_Full']))
          UI:SetSpeakerEmotion("Normal")
        else
          cart = result
          state = 2
        end
      else
        state = 0
      end
    elseif state == 2 then
      local total = 0
      for ii = 1, #cart, 1 do
        total = total + catalog[cart[ii]].Price
      end
      local msg
      if total > GAME:GetPlayerMoney() then
        UI:SetSpeakerEmotion("Angry")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Buy_No_Money']))
        UI:SetSpeakerEmotion("Normal")
        state = 1
      else
        if #cart == 1 then
          local name = catalog[cart[1]].Item:GetDisplayName()
          msg = STRINGS:Format(STRINGS.MapStrings['Shop_Buy_One'], STRINGS:FormatKey("MONEY_AMOUNT", total), name)
        else
          msg = STRINGS:Format(STRINGS.MapStrings['Shop_Buy_Multi'], STRINGS:FormatKey("MONEY_AMOUNT", total))
        end
        UI:ChoiceMenuYesNo(msg, false)
        UI:WaitForChoice()
        result = UI:ChoiceResult()

        if result then
          GAME:RemoveFromPlayerMoney(total)
          for ii = 1, #cart, 1 do
            local item = catalog[cart[ii]].Item
            GAME:GivePlayerItem(item.ID, item.Amount, false)
          end
          for ii = #cart, 1, -1 do
            table.remove(catalog, cart[ii])
            table.remove(SV.mart_shop, cart[ii])
          end

          cart = {}
          SOUND:PlayBattleSE("DUN_Money")
          UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Buy_Complete']))
          state = 0
        else
          state = 1
        end
      end
    elseif state == 3 then
      UI:SellMenu()
      UI:WaitForChoice()
      local result = UI:ChoiceResult()

      if #result > 0 then
        cart = result
        state = 4
      else
        state = 0
      end
    elseif state == 4 then
      local total = 0
      for ii = 1, #cart, 1 do
        local item
        if cart[ii].IsEquipped then
          item = GAME:GetPlayerEquippedItem(cart[ii].Slot)
        else
          item = GAME:GetPlayerBagItem(cart[ii].Slot)
        end
        total = total + item:GetSellValue()
      end
      local msg
      if #cart == 1 then
        local item
        if cart[1].IsEquipped then
          item = GAME:GetPlayerEquippedItem(cart[1].Slot)
        else
          item = GAME:GetPlayerBagItem(cart[1].Slot)
        end
        msg = STRINGS:Format(STRINGS.MapStrings['Shop_Sell_One'], STRINGS:FormatKey("MONEY_AMOUNT", total), item:GetDisplayName())
      else
        msg = STRINGS:Format(STRINGS.MapStrings['Shop_Sell_Multi'], STRINGS:FormatKey("MONEY_AMOUNT", total))
      end
      UI:ChoiceMenuYesNo(msg, false)
      UI:WaitForChoice()
      result = UI:ChoiceResult()

      if result then
        for ii = #cart, 1, -1 do
          if cart[ii].IsEquipped then
            GAME:TakePlayerEquippedItem(cart[ii].Slot, true)
          else
            GAME:TakePlayerBagItem(cart[ii].Slot, true)
          end
        end
        SOUND:PlayBattleSE("DUN_Money")
        GAME:AddToPlayerMoney(total)
        cart = {}
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Sell_Complete']))
        state = 0
      else
        state = 3
      end
    end
  end
end

function mellow_town.SHOP_RIGHT_COUNTER_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  local state = 0
  local repeated = false
  local cart = {}
  local catalog = { }
  for ii = 1, #SV.wares_shop, 1 do
  local base_data = SV.wares_shop[ii]
  local item_data = { Item = RogueEssence.Dungeon.InvItem(base_data.Index, false, base_data.Amount), Price = base_data.Price }
  table.insert(catalog, item_data)
  end


  local chara = CH('MART_Kecleon_Right')
  UI:SetSpeaker(chara)

  while state > -1 do
    if state == 0 then
      local msg = STRINGS:Format(STRINGS.MapStrings['Shop_Intro'])
      if repeated == true then
        msg = STRINGS:Format(STRINGS.MapStrings['Shop_Intro_Return'])
      end
      local shop_choices = {STRINGS:Format(STRINGS.MapStrings['Shop_Option_Buy']), STRINGS:Format(STRINGS.MapStrings['Shop_Option_Sell']),
      STRINGS:FormatKey("MENU_INFO"),
      STRINGS:FormatKey("MENU_EXIT")}
      UI:BeginChoiceMenu(msg, shop_choices, 1, 4)
      UI:WaitForChoice()
      local result = UI:ChoiceResult()
      repeated = true
      if result == 1 then
        if #catalog > 0 then
          --TODO: use the enum instead of a hardcoded number
          UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Buy'], STRINGS:LocalKeyString(26)))
          state = 1
        else
          UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Buy_Empty']))
        end
      elseif result == 2 then
        local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
        if bag_count > 0 then
          --TODO: use the enum instead of a hardcoded number
          UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Sell'], STRINGS:LocalKeyString(26)))
          state = 3
        else
          UI:SetSpeakerEmotion("Angry")
          UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Bag_Empty']))
          UI:SetSpeakerEmotion("Normal")
        end
      elseif result == 3 then
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_001']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_002']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_003']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_004']))
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Info_005']))
      else
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Goodbye']))
        state = -1
      end
    elseif state == 1 then
      UI:ShopMenu(catalog)
      UI:WaitForChoice()
      local result = UI:ChoiceResult()
      if #result > 0 then
        local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
        local bag_cap = GAME:GetPlayerBagLimit()
        if bag_count == bag_cap then
          UI:SetSpeakerEmotion("Angry")
          UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Bag_Full']))
          UI:SetSpeakerEmotion("Normal")
        else
          cart = result
          state = 2
        end
      else
        state = 0
      end
    elseif state == 2 then
      local total = 0
      for ii = 1, #cart, 1 do
        total = total + catalog[cart[ii]].Price
      end
      local msg
      if total > GAME:GetPlayerMoney() then
        UI:SetSpeakerEmotion("Angry")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Buy_No_Money']))
        UI:SetSpeakerEmotion("Normal")
        state = 1
      else
        if #cart == 1 then
          local name = catalog[cart[1]].Item:GetDisplayName()
          msg = STRINGS:Format(STRINGS.MapStrings['Shop_Buy_One'], STRINGS:FormatKey("MONEY_AMOUNT", total), name)
        else
          msg = STRINGS:Format(STRINGS.MapStrings['Shop_Buy_Multi'], STRINGS:FormatKey("MONEY_AMOUNT", total))
        end
        UI:ChoiceMenuYesNo(msg, false)
        UI:WaitForChoice()
        result = UI:ChoiceResult()

        if result then
          GAME:RemoveFromPlayerMoney(total)
          for ii = 1, #cart, 1 do
            local item = catalog[cart[ii]].Item
            GAME:GivePlayerItem(item.ID, item.Amount, false)
          end
          for ii = #cart, 1, -1 do
            table.remove(catalog, cart[ii])
            table.remove(SV.wares_shop, cart[ii])
          end

          cart = {}
          SOUND:PlayBattleSE("DUN_Money")
          UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Buy_Complete']))
          state = 0
        else
          state = 1
        end
      end
    elseif state == 3 then
      UI:SellMenu()
      UI:WaitForChoice()
      local result = UI:ChoiceResult()

      if #result > 0 then
        cart = result
        state = 4
      else
        state = 0
      end
    elseif state == 4 then
      local total = 0
      for ii = 1, #cart, 1 do
        local item
        if cart[ii].IsEquipped then
          item = GAME:GetPlayerEquippedItem(cart[ii].Slot)
        else
          item = GAME:GetPlayerBagItem(cart[ii].Slot)
        end
        total = total + item:GetSellValue()
      end
      local msg
      if #cart == 1 then
        local item
        if cart[1].IsEquipped then
          item = GAME:GetPlayerEquippedItem(cart[1].Slot)
        else
          item = GAME:GetPlayerBagItem(cart[1].Slot)
        end
        msg = STRINGS:Format(STRINGS.MapStrings['Shop_Sell_One'], STRINGS:FormatKey("MONEY_AMOUNT", total), item:GetDisplayName())
      else
        msg = STRINGS:Format(STRINGS.MapStrings['Shop_Sell_Multi'], STRINGS:FormatKey("MONEY_AMOUNT", total))
      end
      UI:ChoiceMenuYesNo(msg, false)
      UI:WaitForChoice()
      result = UI:ChoiceResult()

      if result then
        for ii = #cart, 1, -1 do
          if cart[ii].IsEquipped then
            GAME:TakePlayerEquippedItem(cart[ii].Slot, true)
          else
            GAME:TakePlayerBagItem(cart[ii].Slot, true)
          end
        end
        SOUND:PlayBattleSE("DUN_Money")
        GAME:AddToPlayerMoney(total)
        cart = {}
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Shop_Sell_Complete']))
        state = 0
      else
        state = 3
      end
    end
  end
end

-- Gholdengo Bank
function mellow_town.BANK_COUNTER_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()

  local state = 0
  local repeated = false

  local chara = CH("BANK_Gholdengo")
  UI:SetSpeaker(chara)

  while state > -1 do
    local msg = STRINGS:Format(STRINGS.MapStrings['Bank_Intro_001'])
    if repeated == true then
      msg = STRINGS:Format(STRINGS.MapStrings['Bank_Intro_002'])
    end
    local bank_choices = { { STRINGS:FormatKey('MENU_BANK_MANAGE'), true},
    { STRINGS:FormatKey('MENU_INFO'), true},
    { STRINGS:FormatKey("MENU_CANCEL"), true}}
    UI:BeginChoiceMenu(msg, bank_choices, 1, 3)
    UI:WaitForChoice()
    local result = UI:ChoiceResult()
    repeated = true
    if result == 1 then -- Bank
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Manage'], STRINGS:LocalKeyString(26)))
      UI:BankMenu()
      UI:WaitForChoice()
    elseif result == 2 then
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Info_001']))
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Info_002']))
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Info_003']))
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Info_004']))
    elseif result == 3 then
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Bank_Goodbye']))
      state = -1
    end
  end
end

--Mienshao Moves
function mellow_town.MOVES_COUNTER_Action(obj, activator)
  mellow_town_tutor.MOVES_COUNTER_Action(obj, activator)
end

-- Tinkaton Boxes
function mellow_town.BOX_COUNTER_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine

  local state = 0
  local repeated = false
  local cart = {}
  local price = 150
  local chara = CH('BOX_Tinkaton') --Get Tinkaton
  UI:SetSpeaker(chara)
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(STRINGS.MapStrings['Box_Intro'], STRINGS:FormatKey("MONEY_AMOUNT", price))
			if repeated == true then
				msg = STRINGS:Format(STRINGS.MapStrings['Box_Return'])
			end
			local shop_choices = {STRINGS:Format(STRINGS.MapStrings['Box_Option_Open']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, shop_choices, 1, 3)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
				if bag_count > 0 then
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_Choose'], STRINGS:LocalKeyString(26)))
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_Bag_Empty']))
				end
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_Info_001']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_Info_002']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_Info_003']))
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_Info_004'], STRINGS:FormatKey("MONEY_AMOUNT", price)))
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			UI:AppraiseMenu()
			UI:WaitForChoice()
			local result = UI:ChoiceResult()

			if #result > 0 then
				cart = result
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			local total = #cart * price

			if total > GAME:GetPlayerMoney() then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_No_Money']))
				state = 1
			else
				local msg
				if #cart == 1 then
					local item
					if cart[1].IsEquipped then
						item = GAME:GetPlayerEquippedItem(cart[1].Slot)
					else
						item = GAME:GetPlayerBagItem(cart[1].Slot)
					end
					msg = STRINGS:Format(STRINGS.MapStrings['Box_Choose_One'], STRINGS:FormatKey("MONEY_AMOUNT", total), item:GetDisplayName())
				elseif #cart < 24 then
					msg = STRINGS:Format(STRINGS.MapStrings['Box_Choose_Multi'], STRINGS:FormatKey("MONEY_AMOUNT", total))
				else
					msg = STRINGS:Format(STRINGS.MapStrings['Box_Choose_Max'], STRINGS:FormatKey("MONEY_AMOUNT", total))

				end
				UI:ChoiceMenuYesNo(msg, false)
				UI:WaitForChoice()
				result = UI:ChoiceResult()

				UI:SetSpeakerEmotion("Normal")

				local treasure = {}
				if result then
					for ii = #cart, 1, -1 do
						local box = nil
						local stack = 0
						if cart[ii].IsEquipped then
							box = GAME:GetPlayerEquippedItem(cart[ii].Slot)
							GAME:TakePlayerEquippedItem(cart[ii].Slot, true)
						else
							box = GAME:GetPlayerBagItem(cart[ii].Slot)
							GAME:TakePlayerBagItem(cart[ii].Slot, true)
						end

						local treasure_item = box.HiddenValue
						local itemEntry = _DATA:GetItem(treasure_item)
						local treasure_choice = { Box = box, Item = RogueEssence.Dungeon.InvItem(treasure_item,false,itemEntry.MaxStack)}
						table.insert(treasure, treasure_choice)

						-- note high rarity items
						if itemEntry.Rarity > 0 then
							SV.unlocked_trades[treasure_item] = true
						end
					end
					SOUND:PlayBattleSE("DUN_Money")
					GAME:RemoveFromPlayerMoney(total)
					cart = {}
          -- Special anim for max amount???
					if #treasure >= 24 then
					  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_Start_Max']))
            -- Just one big bonk
            GROUND:EntTurn(chara, Direction.Up)
            GAME:WaitFrames(20)
            GROUND:CharSetAnim(chara, "Charge", true)
            GAME:WaitFrames(40)
            GROUND:CharSetAnim(chara, "Attack", false)
            GAME:WaitFrames(23)
            local shake = RogueEssence.Content.ScreenMover(0, 8, 60)
            GROUND:MoveScreen(shake)
            SOUND:PlayBattleSE("_UNK_DUN_Break")
					  SOUND:PlayBattleSE("DUN_Explosion")
            GAME:WaitFrames(40)

					  GROUND:EntTurn(chara, Direction.Down)
					  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_End_Max_001']))
					  SOUND:PlayFanfare("Fanfare/Treasure")
					  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_End_Max_002']))
          -- Anim if several
					elseif #treasure >= 8 then
					  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_Start']))

            GROUND:EntTurn(chara, Direction.Up)
            GAME:WaitFrames(20)
            GROUND:CharSetAnim(chara, "Attack", false)
            GAME:WaitFrames(23)
            local shake = RogueEssence.Content.ScreenMover(0, 8, 30)
            GROUND:MoveScreen(shake)
            SOUND:PlayBattleSE("_UNK_DUN_Break")
            GAME:WaitFrames(20)

            -- Again
            GROUND:CharSetAnim(chara, "Attack", false)
            GAME:WaitFrames(23)
            local shake = RogueEssence.Content.ScreenMover(0, 8, 30)
            GROUND:MoveScreen(shake)
            SOUND:PlayBattleSE("_UNK_DUN_Break")
            GAME:WaitFrames(10)
            -- Again
            GROUND:CharSetAnim(chara, "Attack", false)
            GAME:WaitFrames(23)
            local shake = RogueEssence.Content.ScreenMover(0, 8, 30)
            GROUND:MoveScreen(shake)
            SOUND:PlayBattleSE("_UNK_DUN_Break")
            GAME:WaitFrames(30)

            GROUND:EntTurn(chara, Direction.Down)
            SOUND:PlayFanfare("Fanfare/Treasure")
            UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_End']))
          -- Anim if just one
					else
					  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_Start']))

					  GROUND:EntTurn(chara, Direction.Up)
					  GAME:WaitFrames(20)
            GROUND:CharSetAnim(chara, "Attack", false)
					  GAME:WaitFrames(23)
					  local shake = RogueEssence.Content.ScreenMover(0, 8, 30)
					  GROUND:MoveScreen(shake)
					  SOUND:PlayBattleSE("_UNK_DUN_Break")
					  GAME:WaitFrames(20)
					  GROUND:EntTurn(chara, Direction.Down)
					  SOUND:PlayFanfare("Fanfare/Treasure")
					  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Box_End']))
					end

					UI:SpoilsMenu(treasure)
					UI:WaitForChoice()

					for ii = 1, #treasure, 1 do
						local item = treasure[ii].Item

						GAME:GivePlayerItem(item.ID, item.Amount, false, item.HiddenValue)
					end

					state = 0
				else
					state = 1
				end
			end
		end
	end
end

-- Polteagiest brew
function mellow_town.TEA_COUNTER_Action(obj, activator)
  mellow_town_tea.TEA_COUNTER_Action(chara, activator)
end

--North Exit
function mellow_town.NorthExit_Touch(obj, activator)
  local dungeon_entrances = {"windswept_trail", "frigid_lake", "verdant_meadow", "magma_tunnel", "lunar_barrow", "primal_canyon","stardust_peak"}
  COMMON.ShowDestinationMenu(dungeon_entrances,"")
end

--East Exit
function mellow_town.EastExit_Touch(obj, activator)
  COMMON.ShowDestinationMenu({"wishing_woods", "dreamscape_cavern"},"")
end

-- Assembly
function mellow_town.Assembly_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:ResetSpeaker()
  COMMON.ShowTeamAssemblyMenu(obj, COMMON.RespawnAllies)
  local partner = CH('Teammate1')
  AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)
  partner.CollisionDisabled = true
end

-- Teammates
function mellow_town.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  UI:SetSpeaker(chara)
  UI:WaitShowDialogue("Let's go, " ..CH("PLAYER"):GetDisplayName().."!")
end

-- Teammates
function mellow_town.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara)
end

function mellow_town.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  COMMON.GroundInteract(activator, chara)
end

-- Mission Test
function mellow_town.MissionTest_Action(obj, activator)
  COMMON.CreateMission("OrangeMiniorRescue",
  { Complete = COMMON.MISSION_INCOMPLETE, Type = COMMON.MISSION_TYPE_RESCUE,
    DestZone = "magma_tunnel", DestSegment = 1, DestFloor = 0,
    FloorUnknown = false,
    TargetSpecies = RogueEssence.Dungeon.MonsterID("minior", 0, "normal", Gender.Genderless),
    ClientSpecies = RogueEssence.Dungeon.MonsterID("minior", 0, "normal", Gender.Genderless) }
  )
  print(SV.missions.Missions["OrangeMiniorRescue"])
end

function mellow_town.Cutscene_Test_Action(obj, activator)
  choices = {"Intro", "Glamour 1", "Glamour 2", "Pyro"}
  UI:BeginChoiceMenu("Choose Cutscene", choices, 1 ,3)
  UI:WaitForChoice()
  result = UI:ChoiceResult()
  if result == 1 then
    SV.mellow_town.CutsceneIntro = false
    GAME:FadeOut(false, 20)
    mellow_town.Cutscene_Intro()
  end
end

-- Cutscenes --
function mellow_town.Cutscene_Intro()
  if SV.mellow_town.CutsceneIntro == false then
    local player = CH("PLAYER")
    local partner = CH("Teammate1")
    local gramps = CH("NPC_Gramps")
    GAME:CutsceneMode(true)
    UI:ResetSpeaker()
    AI:DisableCharacterAI(partner)
    GROUND:Hide("NPC_Drilbur") -- He's in the way so hide him
    GROUND:Hide("NPC_Gramps")
    GROUND:TeleportTo(player, 686, 192, Direction.Left)
    GROUND:TeleportTo(partner, 686, 212, Direction.Left)
    GROUND:TeleportTo(gramps, 412, 24, Direction.Down)
    GAME:FadeIn(20)

    local coro1 = TASK:BranchCoroutine(function() mellow_town.Coro_Walk(partner, Direction.Left, 262, false, 1) end)
    local coro2 = TASK:BranchCoroutine(function() mellow_town.Coro_Walk(player, Direction.Left, 290, false, 1) end)
    TASK:JoinCoroutines({coro1, coro2})
    GROUND:EntTurn(player, Direction.DownRight)
    GROUND:EntTurn(partner, Direction.UpLeft)
    --First Convo Start
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Joyous")
    UI:WaitShowDialogue("Welcome to Mellow Town!")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("It's a little small and empty...[pause=20] But it has everything aspiring adventurers like us need to take on Mystery Dungeons!")
    GROUND:EntTurn(partner, Direction.Right)
    GROUND:EntTurn(player, Direction.Right)
    UI:WaitShowDialogue("Look over here.")

    -- Move Camera
    GAME:MoveCamera(528, 156, 60, false)
    UI:WaitShowDialogue(STRINGS:Format("Pokémon run all sorts of different shops in town, that we can use in exchange for \\uE024."))
    UI:SetSpeakerEmotion("Joyous")
    UI:WaitShowDialogue("The Kecleon Brothers sell loads different goods.[br]The green Kecleon will sell food, throwing items, berries and more.[br]While the purple Kecleon on the right will sell orbs, TMs and other special items!")

    -- Move Camera
    GROUND:EntTurn(partner, Direction.Left)
    GROUND:EntTurn(player, Direction.Left)
    GAME:MoveCamera(216, 168, 60, false)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue(STRINGS:Format("Gholdengo and Gimmighoul run a bank where we can store our spare \\uE024."))
    UI:WaitShowDialogue("And Mrs Kangaskhan on the right can keep our items safe.")

    -- Move Camera
    GROUND:EntTurn(partner, Direction.DownLeft)
    GROUND:EntTurn(player, Direction.DownLeft)
    GAME:MoveCamera(252, 328, 60, false)
    UI:WaitShowDialogue("Mienshao can help us remember or learn new moves..")

    -- Move Camera
    GROUND:EntTurn(partner, Direction.DownRight)
    GROUND:EntTurn(player, Direction.DownRight)
    GAME:MoveCamera(575, 328, 60, false)
    UI:WaitShowDialogue("And Tinkaton can crack open any locked boxes we find.")
    UI:WaitShowDialogue("Polteagiest and Sinistea moved in recently, I think they're opening up a tea stand or something?")

    -- Move Camera
    GAME:MoveCamera(0, 0, 60, true)
    GROUND:EntTurn(partner, Direction.UpLeft)
    GROUND:EntTurn(player, Direction.DownRight)
    UI:SetSpeakerEmotion("Joyous")
    UI:WaitShowDialogue("But yeah! [pause=20]That's pretty much everything.")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("There's not many of us in town. A lot of the Pokémon that come through here stop for a bit while they take on the Mystery Dungeons.")
    UI:WaitShowDialogue("Speaking of which...[pause=0][emote=worried]\nWhere's Gramps? I hope he's not still upset...")

    UI:ResetSpeaker()
    shake = RogueEssence.Content.ScreenMover(0, 12, 20)
    GROUND:MoveScreen(shake)
    SOUND:PlayBattleSE("EVT_Roar")
    UI:WaitShowDialogue(STRINGS:Format("\\uE040: " ..partner:GetDisplayName().. "![pause=0] Where have you been!"))
    GROUND:Unhide("NPC_Gramps")
    GROUND:EntTurn(partner, Direction.Up)
    GROUND:EntTurn(player, Direction.Up)
    GROUND:CharSetEmote(player, "shock", 1)
    GROUND:CharSetEmote(partner, "shock", 1)
    SOUND:PlaySE("Battle/EVT_Emote_Startled_2")
    GAME:WaitFrames(30)
    GROUND:MoveInDirection(gramps, Direction.Down, 130, false, 1)
    UI:SetSpeaker(gramps)
    UI:SetSpeakerEmotion("Angry")
    UI:WaitShowDialogue("[speed=0.7] I've been besides myself with worry all night!\nWhat do you have to say for yourself!")

    GROUND:CharSetEmote(partner, "sweating", 1)
    SOUND:PlaySE("Battle/EVT_Emote_Sweating")
    GAME:WaitFrames(30)
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("surprised")
    UI:WaitShowDialogue("G-gramps![pause=20] I was just-")

    GROUND:CharSetEmote(gramps, "angry", 1)
    SOUND:PlaySE("Battle/EVT_Emote_Complain_2")
    GAME:WaitFrames(30)
    UI:SetSpeaker(gramps)
    UI:SetSpeakerEmotion("Angry")
    UI:WaitShowDialogue("[speed=0.7]I don't want to hear it!")
    UI:WaitShowDialogue("[speed=0.7]You're grounded!")

    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("Angry")
    UI:WaitShowDialogue("What? That's not fair!\n I promised to get " ..player:GetDisplayName().. " home!")


    UI:SetSpeaker(gramps)
    UI:SetSpeakerEmotion("determined")
    UI:WaitShowDialogue("[speed=0.7]What?")
    GROUND:EntTurn(gramps, Direction.DownLeft)
    UI:SetSpeakerEmotion("surprised")
    UI:WaitShowDialogue("[speed=0.7]What!")
    SOUND:PlaySE("Battle/EVT_Emote_Shock_2")
    UI:WaitShowDialogue("[speed=0.7]You're a Minior, aren't you?[pause=20]")
    UI:SetSpeakerEmotion("worried")
    UI:WaitShowDialogue("[speed=0.7]What are you doing here?")

    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("determined")
    UI:WaitShowDialogue("They crashed near [color=#F8A0F8]Wishing Woods[color]!")
    UI:SetSpeakerEmotion("worried")
    UI:WaitShowDialogue("All their friends are missing, so I promised to get them home...")

    GROUND:EntTurn(gramps, Direction.Down)
    UI:SetSpeaker(gramps)
    UI:SetSpeakerEmotion("sad")
    UI:WaitShowDialogue("[speed=0.7]Oh " ..partner:GetDisplayName().. "...")

    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("worried")
    UI:WaitShowDialogue("And I need your help, Gramps. How can we get " ..player:GetDisplayName().. " and their friends back home to space?")

    GROUND:CharSetEmote(gramps, "sweatdrop", 1)
    SOUND:PlaySE("Battle/EVT_Emote_Sweatdrop")
    GROUND:EntTurn(gramps, Direction.Right)
    UI:SetSpeaker(gramps)
    UI:SetSpeakerEmotion("worried")
    UI:WaitShowDialogue("[speed=0.5]........[pause=60]")
    GROUND:EntTurn(gramps, Direction.Down)
    UI:WaitShowDialogue("You made it all the way through [color=#F8A0F8]Wishing Woods[color] and back?")

    GROUND:CharSetAnim(partner, "Nod", false)
    GAME:WaitFrames(30)

    UI:SetSpeakerEmotion("normal")
    UI:WaitShowDialogue("[speed=0.7]Then maybe... [pause=30][color=#F8A0F8]Stardust Peak[color] is the best way to get your friend home.")
    UI:WaitShowDialogue("[speed=0.7]Legends say the mountain is the bridge between our lands and the stars above...")
    UI:WaitShowDialogue("[speed=0.7]And that it's the home of a terrible Pokémon who rules the skies!")

    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("inspired")
    UI:WaitShowDialogue("Woah! Cool!")

    UI:SetSpeaker(gramps)
    UI:SetSpeakerEmotion("determined")
    UI:WaitShowDialogue("[speed=0.7]No! Not cool! Dangerous!")

    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("worried")
    UI:WaitShowDialogue("Gramps...")
    UI:SetSpeakerEmotion("happy")
    UI:WaitShowDialogue("Me and " ..player:GetDisplayName().. " can handle it!")
    UI:WaitShowDialogue("Especially if we can recruit some other friends along the way!")

    UI:SetSpeaker(gramps)
    UI:SetSpeakerEmotion("worried")
    UI:WaitShowDialogue("[speed=0.7]It's dangerous, " ..partner:GetDisplayName().. ", you know that, right?")
    UI:WaitShowDialogue("[speed=0.7]You'll have to go through many other Mystery Dungeons to even get to the foot of the mountain.")

    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("worried")
    UI:WaitShowDialogue("Yeah, but...")
    GROUND:EntTurn(partner, Direction.UpLeft)
    UI:SetSpeakerEmotion("happy")
    UI:WaitShowDialogue("As long as " ..player:GetDisplayName().. " is with me, I'll be okay! They're strong!")

    UI:SetSpeaker(gramps)
    UI:SetSpeakerEmotion("worried")
    GROUND:EntTurn(gramps, Direction.DownLeft)
    UI:WaitShowDialogue("[speed=0.7]Well then, " ..player:GetDisplayName().. ".")

    UI:ChoiceMenuYesNo("[speed=0.7]Will you keep my " ..partner:GetDisplayName().. " safe?", false)
    UI:WaitForChoice()
    ch = UI:ChoiceResult()
    if ch then
      UI:SetSpeaker(gramps)
      UI:SetSpeakerEmotion("sigh")
      UI:WaitShowDialogue("[speed=0.7]Good...")
      UI:SetSpeakerEmotion("determined")
      UI:WaitShowDialogue("[speed=0.7]Then I'm counting on you! If " ..partner:GetDisplayName().. " gets hurt, it's on you!")
    else
        UI:WaitShowDialogue()
    end
    GROUND:EntTurn(gramps, Direction.Down)
    UI:SetSpeakerEmotion("normal")
    UI:WaitShowDialogue("[speed=0.7]If you really want to do this, then I shouldn't stand in your way.")
    UI:SetSpeakerEmotion("teary-eyed")
    UI:WaitShowDialogue("[speed=0.7]Oh...[pause=20] I suppose you had to grow up some day... sniffle...")
    GAME:WaitFrames(30)
    UI:SetSpeakerEmotion("normal")
    UI:WaitShowDialogue("[speed=0.7]Ahem...[pause=20]I think you should probably start your journey at [color=#F8A0F8]Windswept Trail[color].")
    UI:WaitShowDialogue("[speed=0.7]It's a Mystery Dungeon that runs down by the coast, and will get you a step closer to [color=#F8A0F8]Stardust Peak[color].")
    UI:WaitShowDialogue("[speed=0.7]I also have a hunch...[br]If your friend here was found near a Mystery Dungeon, then chances are their other friends will have been drawn to them as well.")
    UI:WaitShowDialogue("[speed=0.7]You may have to look out for hidden areas to find them.")
    UI:WaitShowDialogue("[speed=0.7]Once you clear a dungeon for the first time, it'll be a lot easier to get back there to continue your journey.")
    UI:WaitShowDialogue("[speed=0.7]Make sure you come back to town to rest and resupply before heading out again.")
    UI:WaitShowDialogue("[speed=0.7]And one more thing...")
    UI:ResetSpeaker()
    UI:WaitShowDialogue("Gramps gave you an [color=#F8F800]Adventurer's Badge[color]!")
    UI:SetSpeaker(gramps)
    UI:WaitShowDialogue("[speed=0.7]You can use that to rescue any of " ..player:GetDisplayName().."\'s friends you do encounter.")

    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("teary-eyed")
    UI:WaitShowDialogue("Sniffle...[pause=20] Thanks, Gramps.")

    UI:SetSpeaker(gramps)
    UI:SetSpeakerEmotion("teary-eyed")
    UI:WaitShowDialogue("[speed=0.7]Be safe, and don't do anything reckless...")
    UI:WaitShowDialogue("[speed=0.7]And if you need any advice, just ask.")

    GROUND:CharSetAnim(partner, "Nod", false)
    GAME:WaitFrames(30)
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("teary-eyed")
    UI:WaitShowDialogue("Okay!")
    UI:SetSpeakerEmotion("determined")
    GROUND:EntTurn(partner, Direction.UpLeft)
    UI:WaitShowDialogue("Okay, " ..player:GetDisplayName().. "! Let's go find your friends and get to [color=#F8A0F8]Stardust Peak[color].")
    --End
    COMMON.UnlockWithFanfare("windswept_trail", false)
    SV.mellow_town.CutsceneIntro = true
    GAME:CutsceneMode(false)
    AI:EnableCharacterAI(partner)
  end
end

function mellow_town.Coro_Walk(chara, direction, distance, run, speed)
  GROUND:MoveInDirection(chara, direction, distance, run, speed)
end

return mellow_town
