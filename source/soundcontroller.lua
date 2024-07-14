local sfp <const> = playdate.sound.fileplayer

class("SoundController").extends()

function SoundController:init()
    self.currentBackground = nil
    self.sounds = {
        idleSoundtrack = sfp.new(config.idleSoundtrackPath),
        battleSoundtrack = sfp.new(config.battleSoundtrackPath)
    }
end

-- Function to play the idle soundtrack with blending
function SoundController:playIdleSoundtrack()
    if self.currentBackground ~= self.sounds.idleSoundtrack then
        if self.currentBackground then
            self.currentBackground:setVolume(0, 0, 1) -- Fade out current background over 1 second
        end
        self.currentBackground = self.sounds.idleSoundtrack
        self.currentBackground:setVolume(0) -- Set volume to 0 immediately before playing
        self.currentBackground:play(0)
        self.currentBackground:setVolume(0.3, 0.3, 1) -- Fade in over 1 second
    end
end

-- Function to play the battle soundtrack with blending
function SoundController:playBattleSoundtrack()
    if self.currentBackground ~= self.sounds.battleSoundtrack then
        if self.currentBackground then
            self.currentBackground:setVolume(0, 0, 1) -- Fade out current background over 1 second
        end
        self.currentBackground = self.sounds.battleSoundtrack
        self.currentBackground:setVolume(0) -- Set volume to 0 immediately before playing
        self.currentBackground:play(0)
        self.currentBackground:setVolume(1, 1, 1) -- Fade in over 1 second
    end
end

function SoundController:playCannonShot()
    local cannonShotInstance = playdate.sound.fileplayer.new(config.cannonShotSoundPath)
    cannonShotInstance:play()
end

function SoundController:playCannonHit()
    local cannonHitInstance = playdate.sound.fileplayer.new(config.cannonHitSoundPath)
    cannonHitInstance:play()
end