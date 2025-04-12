require 'minior_jam_game.event_single'
require 'origin.event_battle'
require 'origin.event_misc'
require 'origin.event_mapgen'

---
-- Ends a run in a failure if an allied party member marked with "IsPartner" faints.
-- Additionally, if someone faints and they aren't "IsPartner", then send them home automatically.
-- @tparam nil owner This function accepts four arguments, but none of them are checked.
-- @tparam nil ownerChar
-- @tparam nil context
-- @tparam nil args
-- By Palika
function SINGLE_CHAR_SCRIPT.AllyDeathCheck(owner, ownerChar, context, args)
	local player_count = GAME:GetPlayerPartyCount()
	local guest_count = GAME:GetPlayerGuestCount()

	if player_count < 1 then return end -- If there's no party members then we dont need to do anything

	for i = 0, player_count - 1, 1 do
		local player = GAME:GetPlayerPartyMember(i)
		if player.Dead and player.IsPartner then --someone died
			for j = 0, player_count - 1, 1 do --beam everyone else out
				player = GAME:GetPlayerPartyMember(j)
				if not player.Dead then    --dont beam out whoever died
					--delay between beam outs
					GAME:WaitFrames(60)
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
					player.Dead = true
				end
			end
			--beam out guests
			for j = 0, guest_count - 1, 1 do --beam everyone else out
				guest = GAME:GetPlayerGuestMember(j)
				if not guest.Dead then --dont beam out whoever died
					--delay between beam outs
					GAME:WaitFrames(60)
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(guest, guest, _DATA.SendHomeFX))
					guest.Dead = true
				end
			end
			return --cut the script short here if someone died, no need to check guests
		end
	end

	-- check guests as well
	if guest_count < 1 then return end -- If there's no guest members then we dont need to do anything
	for i = 0, guest_count - 1, 1 do
		local guest = GAME:GetPlayerGuestMember(i)
		if guest.Dead and guest.IsPartner then -- someone died
			-- beam player's team out first
			for j = 0, player_count - 1, 1 do -- beam everyone else out
				player = GAME:GetPlayerPartyMember(j)
				if not player.Dead then  -- dont beam out whoever died
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
					player.Dead = true
					GAME:WaitFrames(60)
				end
			end
			for j = 0, guest_count - 1, 1 do --beam everyone else out
				guest = GAME:GetPlayerGuestMember(j)
				if not guest.Dead then -- dont beam out whoever died
					TASK:WaitTask(_DUNGEON:ProcessBattleFX(guest, guest, _DATA.SendHomeFX))
					guest.Dead = true
					GAME:WaitFrames(60)
				end
			end
		end
	end
end
