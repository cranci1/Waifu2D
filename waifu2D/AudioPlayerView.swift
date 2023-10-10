import UIKit
import AVFoundation

class AudioPlayerView: UIView {

    private var audioPlayer: AVAudioPlayer?

    // List of available audio file names
    private let availableAudioFiles = ["baka", "huge", "nya", "onichan", "sugoi", "tuturu", "yamede", "ara", "uwu", "gah"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAudioPlayer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAudioPlayer()
    }

    private func setupAudioPlayer() {
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        chooseAndPlayAudio()
    }

    private func chooseAndPlayAudio() {
        // Randomly choose from the list of available audio files
        if let randomAudioFileName = availableAudioFiles.randomElement() {
            if let audioPath = Bundle.main.path(forResource: randomAudioFileName, ofType: "mp3") {
                do {
                    let audioData = try Data(contentsOf: URL(fileURLWithPath: audioPath))
                    audioPlayer = try AVAudioPlayer(data: audioData)
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                } catch let error {
                    print("Error initializing or playing audio: \(error.localizedDescription)")
                }
            } else {
                print("Error: Couldn't find the audio file at path.")
            }
        } else {
            print("Error: No available audio files.")
        }
        
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let touchRange: CGFloat = 105.0 // Increase the touch range here

        return hypot(point.x - center.x, point.y - center.y) < touchRange
    }
}
