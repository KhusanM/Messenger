



import UIKit
import AVFoundation

class AudioTVC: UITableViewCell {
    
    static let identifair = "AudioTVC"
    static func unib() -> UINib {
        return UINib(nibName: identifair, bundle: nil)
    }
    var fileTit = ""
    var audioPlayer = AVAudioPlayer()

    @IBOutlet weak var labell: UILabel!
    @IBOutlet weak var slider: UISlider!{
        didSet{
            let image:UIImage? = UIImage(named: "dot")
            slider.setThumbImage(image, for: .normal)
            slider.setThumbImage(image, for: .highlighted)
        }
    }
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var realTimeLbl: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    var urls : [String] = []
    var index : IndexPath!
    var timeSlider : Timer?
    var timeLbl : Timer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        audioPlayer.delegate = self
        slider.value = Float(audioPlayer.duration)
    }
    
    func updateCell(ar: MessageData) {
        
        self.fileTit = ar.audiFiles ?? ""
    }
    
    @IBAction func playBtnPressed(_ sender: Any) {
        
        
        if !audioPlayer.isPlaying {
            
            playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            setUpPlayer()
            audioPlayer.play()
            audioPlayer.prepareToPlay()
            slider.maximumValue = Float(audioPlayer.duration)
            slider.value = 0.0
            timeSlider = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime(_:)), userInfo: nil, repeats: true)
            timeLbl = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime1), userInfo: nil, repeats: true)
        }else {
            playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timeLbl?.invalidate()
            timeSlider?.invalidate()
            audioPlayer.stop()
        }
        
    }
    
    
    @IBAction func sliderDrag(_ sender: Any) {
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval.init(slider.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        slider.value = Float(audioPlayer.currentTime)
    }
    
    
    
}
extension AudioTVC: AVAudioPlayerDelegate  {
    

    func fetchingDocumentDirectory()-> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func setUpPlayer() {
        
        let audioFileName = fetchingDocumentDirectory().appendingPathComponent(String(fileTit.suffix(40)))
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileName)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }
            
        }catch {
            print(error)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player.duration == 0 {
            player.stop()
            playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)

        }
        print(flag,"recorddidFinish")
            playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
}
// MARK: @OBJ
extension AudioTVC {
    @objc func updateTime1() {
        
     if audioPlayer.isPlaying == false {
         timeLbl?.invalidate()
         timeSlider?.invalidate()
     }
         let currentTime = Int(audioPlayer.currentTime)
         let duration = Int(audioPlayer.duration)
         let total = currentTime - duration
         _ = String(total)

         let minutes = currentTime/60
         let seconds = currentTime - minutes / 60

         labell.text = NSString(format: "%02d:%02d", minutes,seconds) as String
     }

     @objc func updateTime(_ timer: Timer) {
         slider.value = Float(audioPlayer.currentTime)
     }

     
}
