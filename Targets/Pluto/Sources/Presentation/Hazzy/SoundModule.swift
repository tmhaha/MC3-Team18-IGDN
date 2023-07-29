//
//  SoundModule.swift
//  MC3_Hazzy
//
//  Created by 고혜지 on 2023/07/07.
//

import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let shared: SoundManager = SoundManager()
    private override init() {
        super.init()
        playBackgroundMusic(.Lobby)
    }
    
    private var backgroundMusic: AVAudioPlayer? = nil
    private var ambienceSound: AVAudioPlayer? = nil
    private var soundEffects: [AVAudioPlayer] = []
    private var thrustSound: AVAudioPlayer? = nil

    let chaterMusics: [Music] = [.Chapter1, .Chapter2, .Chapter3, .Chapter4, .Chapter5, .Chapter6]
    let allAmbienceCases: [Ambience] = Ambience.allCases
    
    func playBackgroundMusic(_ music: Music) {
        guard let soundURL = Bundle.main.url(forResource: music.rawValue, withExtension: "mp3") else {
            print("Sound file not found.")
            return
        }
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = Float(SettingData.shared.musicVolume)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            backgroundMusic = audioPlayer
        } catch let error {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func playAmbience(_ ambience: Ambience) {
        guard let soundURL = Bundle.main.url(forResource: ambience.rawValue, withExtension: "mp3") else {
            print("Sound file not found.")
            return
        }
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = Float(SettingData.shared.isAmbianceOn ? 0.1 : 0)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            ambienceSound = audioPlayer
        } catch let error {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func playSoundEffect(_ effect: Effect) {
        guard let soundURL = Bundle.main.url(forResource: effect.rawValue, withExtension: "mp3") else {
            print("Sound file not found.")
            return
        }

        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer.delegate = self
            audioPlayer.volume = Float(SettingData.shared.effectVolume)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            soundEffects.append(audioPlayer)
        } catch let error {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func playThrust() {
        guard let soundURL = Bundle.main.url(forResource: "thrust5", withExtension: "mp3") else {
            print("Sound file not found.")
            return
        }
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer.volume = Float(SettingData.shared.effectVolume)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            thrustSound = audioPlayer
        } catch let error {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func stopThrust() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.thrustSound!.volume > 0.1 {
                self.thrustSound!.volume -= 0.1
            } else {
                self.thrustSound!.stop()
                timer.invalidate()
            }
        }
    }
    
    func updateVolume(isBackgroundMusic: Bool, isAmbience: Bool, volume: Float) { // TODO: 수정필요!
        if isBackgroundMusic {
            backgroundMusic?.volume = volume
        } else if isAmbience {
            ambienceSound?.volume = volume
        } else {
            for audioPlayer in soundEffects {
                audioPlayer.volume = volume
            }
        }
    }
    
    // AVAudioPlayerDelegate method to remove stopped audio players from the array
    /*
     ChatGPT
     audioPlayerDidFinishPlaying(_:successfully:) 메서드는 AVAudioPlayer 인스턴스의 재생이 완료된 후 호출되는 AVAudioPlayerDelegate 프로토콜의 메서드입니다. 이 메서드는 재생이 성공적으로 완료되었는지 여부를 전달하는 flag 매개변수와 함께 호출됩니다.

     audioPlayerDidFinishPlaying(_:successfully:) 메서드는 다음과 같은 상황에서 사용될 수 있습니다:

     오디오 재생이 정상적으로 완료되었을 때: 오디오 파일이 끝까지 재생된 후에 해당 메서드가 호출되며, flag 매개변수는 true 값을 가집니다. 이를 활용하여 재생이 완료되었음을 처리할 수 있습니다. 예를 들어, 재생이 완료된 후에 다음 오디오를 재생하거나 해당 오디오를 다시 재생하도록 할 수 있습니다.
     재생 중에 재생 오류가 발생한 경우: 오디오 파일을 재생하는 동안 오류가 발생하여 재생이 중단된 경우에도 audioPlayerDidFinishPlaying(_:successfully:) 메서드가 호출됩니다. 이 경우 flag 매개변수는 false 값을 가지므로, 오디오 재생이 성공적으로 완료되지 않았음을 나타낼 수 있습니다. 이를 활용하여 오류 처리를 수행하거나 사용자에게 알림을 표시할 수 있습니다.
     위의 예시에서 audioPlayerDidFinishPlaying(_:successfully:) 메서드는 재생이 완료된 AVAudioPlayer 인스턴스를 배열에서 제거하는 역할을 수행하고 있습니다. 이를 통해 재생이 완료된 오디오를 적절하게 관리할 수 있습니다.
     */
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("function called")
        if let index = soundEffects.firstIndex(of: player) {
            soundEffects.remove(at: index)
        }
    }
}

enum Music: String, CaseIterable {
    case Chapter1 = "Chapter1"
    case Chapter2 = "chapter 2"
    case Chapter3 = "chapter 3"
    case Chapter4 = "chapter 4"
    case Chapter5 = "chapter 5"
    case Chapter6 = "chapter 6"
    case Lobby = "main"
    case Story1 = "Driving Wings"
    case Story2 = "everything ends eventually"
    case Story3 = "main-green to blue"
}

enum Ambience: String, CaseIterable {
    case Chapter1 = "chap1 neptune_1"
    case Chapter2 = "chap2 uranus"
    case Chapter3 = "chap3 saturn"
    case Chapter4 = "chap4 jupiter"
    case Chapter5 = "chap5 mars"
    case Chapter6 = "chap6 earth"
}

enum Effect: String {
    case ChangeColor = "change color"
    case Fail = "fail"
    case Fail2 = "fail2"
    case Pause = "pause"
    case Play = "play"
    case Success = "success"
    case ThrustEmpty = "thrust_empty"
    case Thrust = "thrust"
}
