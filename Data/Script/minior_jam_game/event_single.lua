require 'minior_jam_game.common'

function SINGLE_CHAR_SCRIPT.WishingWoodsGameTutorial(owner, ownerChar, context, args)
  local floor = args.Floor
  local chara = GAME:GetPlayerPartyMember(1)
  local player = GAME:GetPlayerPartyMember(0)
  PrintInfo("Test")

  if floor == 1 then
    if SV.wishing_woods.TutorialProgress < 1 then
      SOUND:PlayFanfare("Fanfare/Note")
      UI:SetSpeaker(chara)
      UI:WaitShowDialogue("Okay, let's head for the stairs![pause=0] You can attack enemies by pressing " ..STRINGS:LocalKeyString(2) .. ".[pause=0] Enemies won't move or attack until we do.")
      UI:WaitShowDialogue("You can also moves by holding " ..STRINGS:LocalKeyString(4).. ", then pressing "..STRINGS:LocalKeyString(21).. ",[pause=10] " ..STRINGS:LocalKeyString(22).. ",[pause=10] " ..STRINGS:LocalKeyString(23).. ",[pause=10] or " ..STRINGS:LocalKeyString(24).. " to use the corresponding move.")
      UI:WaitShowDialogue("Alternatively,[pause=10] press " .. STRINGS:LocalKeyString(9) .. " and choose the Moves option or press " ..STRINGS:LocalKeyString(11).. " to access the Moves menu.")
      UI:WaitShowDialogue("We'll only earn Exp. Points if we use at least one move against a foe, meaning we can't just use basic " ..STRINGS:LocalKeyString(2).. " attacks.")
      UI:WaitShowDialogue("If we defeat enough enemies and gain enough Exp. Points, we'll level up!")
      UI:WaitShowDialogue("But if either of us faint, we'll have to run away and escape from the dungeon.")
      SV.wishing_woods.TutorialProgress = 1
      GAME:WaitFrames(20)
    end
  elseif floor == 2 then
    if SV.wishing_woods.TutorialProgress < 2 then
      SOUND:PlayFanfare("Fanfare/Note")
      UI:SetSpeaker(chara)
      UI:WaitShowDialogue("See these items we've been picking up? We can store them in our adventuring bag.[pause=0] Items have all sorts of helpful effects!")
			UI:WaitShowDialogue("To see what items we have in the bag, press " ..STRINGS:LocalKeyString(9).. " and choose the Items option.")
      UI:WaitShowDialogue("If you start getting hungry, you can eat a food item from the bag.[pause=0] If our bellies run empty, we'll start losing health until we faint or eat something!")
      SV.wishing_woods.TutorialProgress = 2
      GAME:WaitFrames(20)
    end
  elseif floor == 3 then
    if SV.wishing_woods.TutorialProgress < 3 then
      SOUND:PlayFanfare("Fanfare/Note")
      UI:SetSpeaker(chara)
      UI:WaitShowDialogue("You can hold " .. STRINGS:LocalKeyString(3) .. " to run![pause=0] This doesn't let us travel more distance in a single turn, but it does mean we can navigate the dungeon faster.")
      UI:WaitShowDialogue("You can also hold " ..STRINGS:LocalKeyString(5).. " to look in any direction you press without moving.")
      UI:WaitShowDialogue("Just make sure to keep an eye out for any traps while exploring! If you step on one, or use a move that will hit one, we'll be in for a nasty surprise!")
      SV.wishing_woods.TutorialProgress = 3
      GAME:WaitFrames(20)
    end
  end
end
