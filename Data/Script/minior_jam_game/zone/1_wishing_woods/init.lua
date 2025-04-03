--[[
    init.lua
    Created: 03/25/2025 18:43:16
    Description: Autogenerated script file for the map 1_wishing_woods.
]]--
-- Commonly included lua functions and data
require 'origin.common'

-- Package name
local 1_wishing_woods = {}

-------------------------------
-- Zone Callbacks
-------------------------------
---1_wishing_woods.Init(zone)
--Engine callback function
function 1_wishing_woods.Init(zone)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_1_wishing_woods")

end

---1_wishing_woods.EnterSegment(zone, rescuing, segmentID, mapID)
--Engine callback function
function 1_wishing_woods.EnterSegment(zone, rescuing, segmentID, mapID)


end

---1_wishing_woods.ExitSegment(zone, result, rescue, segmentID, mapID)
--Engine callback function
function 1_wishing_woods.ExitSegment(zone, result, rescue, segmentID, mapID)
  if segmentID == 0 then
    COMMON.EndDungeonDay(result, '1_mellow_town', -1, 0, 0)
  else
    PrintInfo("No exit procedure found!")
  COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
  end
end

---1_wishing_woods.Rescued(zone, name, mail)
--Engine callback function
function 1_wishing_woods.Rescued(zone, name, mail)


end

return 1_wishing_woods
