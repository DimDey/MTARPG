NotificationsAudio = {
    pSound = 'Resources/Sounds/notification.mp3';

    playSound = function(self)
        local sound = playSound(self.pSound)
	    setSoundVolume(sound, 1)
    end;
}