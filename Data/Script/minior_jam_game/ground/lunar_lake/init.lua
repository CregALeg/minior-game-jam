--[[
    init.lua
    Created: 04/14/2025 19:57:23
    Description: Autogenerated script file for the map lunar_lake.
]]--
-- Commonly included lua functions and data
require 'origin.common'

-- Package name
local lunar_lake = {}

-------------------------------
-- Map Callbacks
-------------------------------
---lunar_lake.Init(map)
--Engine callback function
function lunar_lake.Init(map)


end

---lunar_lake.Enter(map)
--Engine callback function
function lunar_lake.Enter(map)

  COMMON.RespawnAllies()

  GAME:CutsceneMode(true)

  local player = CH("PLAYER")
  local partner = CH("PARTNER")
  local team2 = CH("TEAMMATE2")
  local team3 = CH("TEAMMATE3")
  local ursa = CH("BOSS_Ursaluna")

  if SV.lunar_barrow.BossDefeated ~= true then -- First time
    if SV.lunar_barrow.BossCutsceneHad ~= true then --Check if not done this before.
      local coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(player, Direction.Up, 48, false, 1) end)
      local coro2 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(partner, Direction.Up, 48, false, 1) end)


      GAME:FadeIn(20)
      TASK:JoinCoroutines({coro1, coro2})
      GAME:WaitFrames(60)
      GAME:MoveCamera(0, -80, 60, true)

      UI:SetSpeaker(ursa)
      UI:WaitShowDialogue("You...[pause=40] Why do you trespass here?")

      GROUND:CharSetEmote(partner, "sweating", 1)
      SOUND:PlaySE("Battle/EVT_Emote_Sweating")
      GAME:WaitFrames(30)
      UI:SetSpeaker(partner)
      UI:SetSpeakerEmotion("surprised")
      UI:WaitShowDialogue("Wha...!")
      UI:SetSpeakerEmotion("stunned")
      UI:WaitShowDialogue("We're just...[pause=30] Passing through on the way to [color=#F8A0F8]Stardust Peak[color].")

      UI:SetSpeaker(player)
      UI:SetSpeakerEmotion("stunned")
      UI:WaitShowDialogue("We mean you no harm![pause=30] Honest!")

      GROUND:EntTurn(ursa, Direction.Down)
      UI:SetSpeaker(ursa)
      UI:WaitShowDialogue("I...[pause=30] Do not believe you, tresspassers.")
      UI:WaitShowDialogue("Only the strong have the right to challenge the Peak!")
      UI:WaitShowDialogue("And you...")
      UI:WaitShowDialogue("I doubt your strength.")

      UI:SetSpeaker(partner)
      UI:SetSpeakerEmotion("angry")
      UI:WaitShowDialogue("Hey![pause=20] We're plenty tough enough!")
      UI:WaitShowDialogue("We could beat you!")

      UI:SetSpeaker(player)
      GROUND:CharSetEmote(player, "sweating", 1)
      SOUND:PlaySE("Battle/EVT_Emote_Sweating")
      GAME:WaitFrames(30)
      UI:SetSpeakerEmotion("Worried")
      UI:WaitShowDialogue( partner:GetDisplayName().."...")

      UI:SetSpeaker(ursa)
      UI:WaitShowDialogue("Then prove it!")
      SOUND:PlayBattleSE("EVT_Roar")
      GROUND:CharWaitAnim(ursa, "RearUp")
      UI:WaitShowDialogue("I, " ..ursa:GetDisplayName().. ", shall test your mettle!")

      SV.lunar_barrow.BossCutsceneHad = true
    else -- Done it before
      local coro1 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(player, Direction.Up, 48, false, 1) end)
      local coro2 = TASK:BranchCoroutine(function() GROUND:MoveInDirection(partner, Direction.Up, 48, false, 1) end)

      TASK:JoinCoroutines({coro1, coro2})
      GAME:WaitFrames(60)
      GAME:MoveCamera(0, -80, 60, true)

      UI:SetSpeaker(ursa)
      UI:WaitShowDialogue("You return...")

      UI:SetSpeaker(partner)
      UI:SetSpeakerEmotion("angry")
      UI:WaitShowDialogue("Yeah! And this time, we won't lose!")

      GROUND:EntTurn(ursa, Direction.Down)
      UI:SetSpeaker(ursa)
      UI:WaitShowDialogue("Then prove it!")
      SOUND:PlayBattleSE("EVT_Roar")
      GROUND:CharWaitAnim(ursa, "RearUp")
      UI:WaitShowDialogue("I, " ..ursa:GetDisplayName().. ", shall test your mettle!")
    end
    -- End of initial cutscene
    COMMON.BossTransition()

    GAME:CutsceneMode(false)

    GAME:ContinueDungeon('lunar_barrow', 1, 0, 0)
  else --After defeating
    GROUND:TeleportTo(player, 288, 360, Direction.Up)
    GROUND:TeleportTo(partner, 312, 360, Direction.Up)

    if team2 ~= nil then
      GROUND:TeleportTo(team2, 264, 384, Direction.Up)
    end
    if team3 ~= nil then
      GROUND:TeleportTo(team3, 336, 384, Direction.Up)
    end

    GAME:MoveCamera(0, -60, 1, true)

    GROUND:EntTurn(ursa, Direction.Down)
    GROUND:CharSetAnim(ursa, "Charge", true)

    GAME:FadeIn(20)

    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion(sigh)
    UI:WaitShowDialogue("We...[pause=20] We did it...")
    UI:SetSpeakerEmotion("happy")
    UI:WaitShowDialogue("We beat " ..ursa:GetDisplayName().. "!")
    GAME:WaitFrames(30)
    shake = RogueEssence.Content.ScreenMover(0, 12, 20)
    GROUND:MoveScreen(shake)
    SOUND:PlayBattleSE("EVT_Roar")
    GROUND:CharWaitAnim(ursa, "RearUp")

    UI:SetSpeaker(ursa)
    UI:WaitShowDialogue("It seems I underestimated you.")
    UI:WaitShowDialogue("Your strength is far greater than it appears.")
    GROUND:EntTurn(ursa, Direction.Up)
    UI:WaitShowDialogue("...")
    UI:WaitShowDialogue("You may proceed.[pause=0] You have earned that right.")

    GAME:WaitFrames(30)
    UI:SetSpeaker(player)
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Okay![pause=30] Thanks, " ..ursa:GetDisplayName().."!")
    GROUND:CharTurnToChar(player, partner)
    UI:WaitShowDialogue("Let's go, " ..partner:GetDisplayName().."!")

    GROUND:CharTurnToChar(partner, player)
    UI:SetSpeaker(partner)
    UI:SetSpeakerEmotion("determined")
    GROUND:CharWaitAnim(partner, "Nod")
    UI:WaitShowDialogue("Right.")

    GAME:FadeOut(false, 30)
    GAME:WaitFrames(30)
    GAME:CutsceneMode(false)
    COMMON.UnlockWithFanfare('primal_canyon', true)
    COMMON.EndDungeonDay(RogueEssence.Data.GameProgress.ResultType.Cleared, 'mellow_town', -1, 0, 1)
  end

end

---lunar_lake.Exit(map)
--Engine callback function
function lunar_lake.Exit(map)


end

---lunar_lake.Update(map)
--Engine callback function
function lunar_lake.Update(map)


end

---lunar_lake.GameSave(map)
--Engine callback function
function lunar_lake.GameSave(map)


end

---lunar_lake.GameLoad(map)
--Engine callback function
function lunar_lake.GameLoad(map)

end

-------------------------------
-- Entities Callbacks
-------------------------------


return lunar_lake
