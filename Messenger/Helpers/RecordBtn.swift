//
//  RecordBtn.swift
//  Messages
//
//  Created by Kuziboev Siddikjon on 8/17/21.
//

import UIKit
import AVFoundation
//import Lottie
protocol RecordBtnDelegate {
    func getUrl(url: String)
}

class RecordBtn: UIButton {
    var time: Timer?
    var pulse : PulseAnimation?
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
   
    var audioRecorder: AVAudioRecorder = AVAudioRecorder()
    
    var delegate: RecordBtnDelegate?
    var fileName: String?
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
   
    var engine = AVAudioEngine()
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("test.caf")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        audioRecorder.delegate = self
        setUpRecorder()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
                       self.addGestureRecognizer(longPress)
        
        engineFunc()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        audioRecorder.delegate = self
        setUpRecorder()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
                       self.addGestureRecognizer(longPress)
        
        engineFunc()
    }
    
    func engineFunc(){
        let file: AVAudioFile
                do {
                    file = try AVAudioFile(forWriting: url, settings: engine.inputNode.outputFormat(forBus: 0).settings)
                } catch {
                    print("Error: \(error)")
                    return
                }
        

        engine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: engine.inputNode.outputFormat(forBus: 0)) { (buffer, time) -> Void in
                    do {
                        try file.write(from: buffer)
                    } catch {
                        print("Error: \(error)")
                    }
                }
    }
    
    @objc  func longPress(gesture: UILongPressGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        if gesture.state == UIGestureRecognizer.State.began {
            
            feedbackGenerator.impactOccurred()
            setUpRecorder()
            
            self.addSubview(view)
            time = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [self] _ in
                self.backgroundColor = .systemGreen
                    
                //self.setImage(UIImage(systemName: "mic.fill"), for: .normal)
                self.tintColor = .clear
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: .curveEaseIn) {
                    self.transform = .init(scaleX: 1.6, y: 1.6)
                    
                } completion: { _ in
                    
                    
                }
                
                pulse = PulseAnimation(numberOfPulse: Float.infinity, radius: 40, postion: view.center)
                pulse?.animationDuration = 4
                pulse?.numebrOfPulse = 1
                pulse?.backgroundColor = UIColor.systemGreen.cgColor

                view.layer.insertSublayer(pulse ?? self.layer, below: view.layer)
                
            })
            audioRecorder.record()
            //ENgine
            do {
                // Start engine
                try engine.start()
                
                // Toggle button title
                
            } catch {
                print("Error: \(error)")
            }
            
            
        }else if gesture.state == UIGestureRecognizer.State.ended {
            
            self.backgroundColor = .clear
            
            self.transform = .identity

            
            self.tintColor = .darkGray
            time?.invalidate()
            view.removeFromSuperview()
            audioRecorder.stop()
            engine.stop()

        }
      }
    
    
    
    
}

//MARK:-AudioTVC Delegates
extension RecordBtn: AVAudioRecorderDelegate {
    
    func fetchingDocumentDirectory()-> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setUpRecorder() {
        
        fileName = NSUUID().uuidString + ".m4a"
        let audioFileName = fetchingDocumentDirectory().appendingPathComponent(fileName ?? "ee")
        
        let recordSetting = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.2 ] as [String: Any]
        
        do {
            
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: recordSetting)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            
        }catch {
            
            print(error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            delegate?.getUrl(url: recorder.url.absoluteString)
        }
    }
}

