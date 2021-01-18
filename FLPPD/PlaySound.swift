//
//  PlaySound.swift
//  FLPPD
//
//  Created by Vlad Konon on 01/09/18.
//  Copyright © 2018 New Centuri Properties LLC. All rights reserved.
//

import Foundation
import AudioToolbox

class Sounds {
    static let `default` = Sounds()
    internal var soundId: SystemSoundID = 0
    init() {
        AudioServicesCreateSystemSoundID(Bundle.main.url(forResource: "newMessage", withExtension: "wav")! as CFURL, &soundId)
        AudioServicesAddSystemSoundCompletion(soundId, nil, nil, { (soundId, clientData) -> Void in
           
        }, nil)
    }
    deinit {
         AudioServicesDisposeSystemSoundID(soundId)
    }
    func playSound(){
        AudioServicesPlaySystemSound(soundId)
    }
}
