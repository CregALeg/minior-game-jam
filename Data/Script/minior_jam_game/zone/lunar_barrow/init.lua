--[[
    init.lua
    Created: 04/14/2025 18:58:42
    Description: Autogenerated script file for the map lunar_barrow.
]]--
-- Commonly included lua functions and data
require 'origin.common'

-- Package name
local lunar_barrow = {}

-------------------------------
-- Zone Callbacks
-------------------------------
---lunar_barrow.Init(zone)
--Engine callback function
function lunar_barrow.Init(zone)


end

---lunar_barrow.EnterSegment(zone, rescuing, segmentID, mapID)
--Engine callback function
function lunar_barrow.EnterSegment(zone, rescuing, segmentID, mapID)


end

---lunar_barrow.ExitSegment(zone, result, rescue, segmentID, mapID)
--Engine callback function
function lunar_barrow.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_lunar_barrow result "..tostring(result).." segment "..tostring(segmentID).."\n\n\n")

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  if exited == true then
    -- do nothing???
  elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
    UI:SetSpeakerEmotion("Pain")
    UI:WaitShowDialogue("Urk...[pause=20] This is harder than I thought...[pause=20] Let's head home for now...")
    COMMON.EndDungeonDay(result, 'mellow_town', -1, 0, 1)
  else
    if segmentID == 0 then -- Exiting from main dungeon
      if SV.lunar_barrow.BossDefeated == false then --Checks if boss is dead
        GAME:EnterZone('lunar_barrow', -1, 0, 0)--If not, send to Ground Map for cutscene. Cutscene then sends back to main.
          -- Shouldn't send here if boss has already been beaten.
      else
        COMMON.UnlockWithFanfare('primal_canyon', true)
        COMMON.EndDungeonDay(result, 'mellow_town', -1, 0, 1)
      end
    elseif segmentID == 1 then -- Exiting from boss room for the first time.
      SV.lunar_barrow.BossDefeated = true
      GAME:EnterZone('lunar_barrow', -1, 0, 0)
    end
  end
  local quest = SV.missions.Missions["IndigoMiniorRescue"]
  if quest ~= nil then
    if quest.Complete == COMMON.MISSION_COMPLETE then
      UI:WaitShowDialogue("You rescued Indigo Minior!") -- Test dialogue
      COMMON.CompleteMission("IndigoMiniorRescue")
    end
  end

end

---lunar_barrow.Rescued(zone, name, mail)
--Engine callback function
function lunar_barrow.Rescued(zone, name, mail)


end

return lunar_barrow
