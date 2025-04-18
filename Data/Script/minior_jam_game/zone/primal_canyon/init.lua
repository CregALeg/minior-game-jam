--[[
    init.lua
    Created: 04/10/2025 21:15:36
    Description: Autogenerated script file for the map primal_canyon.
]]--
-- Commonly included lua functions and data
require 'origin.common'

-- Package name
local primal_canyon = {}

-------------------------------
-- Zone Callbacks
-------------------------------
---primal_canyon.Init(zone)
--Engine callback function
function primal_canyon.Init(zone)


end

---primal_canyon.EnterSegment(zone, rescuing, segmentID, mapID)
--Engine callback function
function primal_canyon.EnterSegment(zone, rescuing, segmentID, mapID)


end

---primal_canyon.ExitSegment(zone, result, rescue, segmentID, mapID)
--Engine callback function
function primal_canyon.ExitSegment(zone, result, rescue, segmentID, mapID)
  PrintInfo("=>> ExitSegment_primal_canyon result "..tostring(result).." segment "..tostring(segmentID).."\n\n\n")

  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  if exited == true then
    -- do nothing???
  elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
    UI:SetSpeaker(GAME:GetPlayerPartyMember(1))
    UI:SetSpeakerEmotion("Pain")
    UI:WaitShowDialogue("Urk...[pause=20] This is harder than I thought...[pause=20] Let's head home for now...")
    COMMON.EndDungeonDay(result, 'mellow_town', -1, 0, 1)
  else
    --COMMON.UnlockWithFanfare('stardust_peak', true)
    COMMON.EndDungeonDay(result, 'mellow_town', -1, 0, 1)
  end
  local quest = SV.missions.Missions["YellowMiniorRescue"]
  if quest ~= nil then
    if quest.Complete == COMMON.MISSION_COMPLETE then
      UI:WaitShowDialogue("You rescued Yellow Minior!") -- Test dialogue
      COMMON.CompleteMission("YellowMiniorRescue")
    end
  end
end


---primal_canyon.Rescued(zone, name, mail)
--Engine callback function
function primal_canyon.Rescued(zone, name, mail)


end

return primal_canyon
