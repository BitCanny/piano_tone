//
//  TuningFork.swift
//  TuningFork
//
//  Copyright (c) 2015 Comyar Zaheri. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//


// MARK:- Imports

import AudioKit
import Chronos


// MARK:- Constants

private let flats = ["C", "D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B"]
private let sharps = ["C", "C♯","D","D♯","E","F","F♯","G","G♯","A","A♯","B"]
private let frequencies: [Float] = [
    16.35, 17.32, 18.35, 19.45, 20.60, 21.83, 23.12, 24.50, 25.96, 27.50, 29.14, 30.87, // 0
    32.70, 34.65, 36.71, 38.89, 41.20, 43.65, 46.25, 49.00, 51.91, 55.00, 58.27, 61.74, // 1
    65.41, 69.30, 73.42, 77.78, 82.41, 87.31, 92.50, 98.00, 103.8, 110.0, 116.5, 123.5, // 2
    130.8, 138.6, 146.8, 155.6, 164.8, 174.6, 185.0, 196.0, 207.7, 220.0, 233.1, 246.9, // 3
    261.6, 277.2, 293.7, 311.1, 329.6, 349.2, 370.0, 392.0, 415.3, 440.0, 466.2, 493.9, // 4
    523.3, 554.4, 587.3, 622.3, 659.3, 698.5, 740.0, 784.0, 830.6, 880.0, 932.3, 987.8, // 5
    1047 , 1109 , 1175 , 1245 , 1319 , 1397 , 1480 , 1568 , 1661 , 1760 , 1865 , 1976,  // 6
    2093 , 2217 , 2349 , 2489 , 2637 , 2794 , 2960 , 3136 , 3322 ,3520  , 3729 , 3951,  // 7
    4186 , 4435 , 4699 , 4978 , 5274 , 5588 , 5920 , 6272 , 6645 , 7040 , 7459 , 7902   // 8
  
]




// MARK:- TunerDelegate Protocol

/**
Types adopting the TunerDelegate protocol act as callbacks for Tuners and are
the mechanism by which you may receive and respond to new information decoded
by a Tuner.
*/
@objc public protocol TunerDelegate {
    
    /**
    Called by a Tuner on each update.
    
    - parameter tuner: Tuner that performed the update.
    - parameter output: Contains information decoded by the Tuner.
    */
    func tunerDidUpdate(tuner: Tuner, output: TunerOutput)
}

// MARK:- TunerOutput

/**
Contains information decoded by a Tuner, such as frequency, octave, pitch, etc.
*/
@objc public class TunerOutput: NSObject {
    
    /**
    The octave of the interpreted pitch.
    */
    public private(set) var octave: Int = 0
    
    /**
    The interpreted pitch of the microphone audio.
    */
    public private(set) var pitch: String = ""
    
    /**
    The difference between the frequency of the interpreted pitch and the actual
    frequency of the microphone audio.
    
    For example if the microphone audio has a frequency of 432Hz, the pitch will
    be interpreted as A4 (440Hz), thus making the distance -8Hz.
    */
    public private(set) var distance: Float = 0.0
    
    /**
    The amplitude of the microphone audio.
    */
    public private(set) var amplitude: Float = 0.0
    
    /**
    The frequency of the microphone audio.
    */
    public private(set) var frequency: Float = 0.0
    
    
    
    private override init() {}
}


// MARK:- Tuner

/**
A Tuner uses the devices microphone and interprets the frequency, pitch, etc.
*/
@objc public class Tuner: NSObject {
    
    /** 
    Object adopting the TunerDelegate protocol that should receive callbacks
    from this tuner.
    */
    public var delegate: TunerDelegate?
    public var timerTime: Double
    public var cutoffAmplitude : Float
    private let threshold: Float
    public let microphone: AKMicrophone
    private let analyzer: AKAudioAnalyzer
    private var timer: DispatchTimer?
    private var oldKey : String = ""
    private var olderKey : String = ""
    public var isDataToBeSent : Bool = true
    var keyFreq : Int = 0
    private var freqArray : [Float] = []
    private var ampArray : [Float] = []
    private var freqToSend : Float = 0
    private var ampToSend : Float = 0
    /**
    Initializes a new Tuner.
    
    - parameter threshold: The minimum amplitude to recognize, must not be negative
    */
    public init(threshold: Float = 0.0) {
        self.timerTime = 0.01
        self.cutoffAmplitude = 0.001
        self.threshold = abs(threshold)
        isDataToBeSent = true
        microphone = AKMicrophone()
        analyzer = AKAudioAnalyzer(input: microphone.output)
        AKOrchestra.addInstrument(microphone)
        AKOrchestra.addInstrument(analyzer)
        
    }
    
    /**
    Starts the tuner.
    */
    public func start() {
        AKSettings.shared().audioInputEnabled = true
        microphone.start()
        analyzer.start()
        timer = DispatchTimer(interval: self.timerTime, closure: { (t, i) -> Void in
            if let d = self.delegate
            {
                let f = self.analyzer.trackedFrequency.value
                let a = self.analyzer.trackedAmplitude.value
                if a > self.cutoffAmplitude
                {
                    let dataType : Bool = self.isReliableData(f, amplitude: a )
                    if dataType == true  {
                        let output = Tuner.newOutput(f,a)
                        self.isDataToBeSent = false
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                 d.tunerDidUpdate(self, output: output)
                            })
                     }
                }
                else
                {
                    NSLog("XXXXXXXXXXAmp=%f,Freq=%f,Cut=%f", a,f,self.cutoffAmplitude)
                    self.oldKey = ""
                    self.olderKey = ""
                    self.keyFreq = 0
                }
                    
            }
        })
        
        
        timer?.start(true)
    }
    
    /**
    Stops the tuner.
    */
    public func stop() {
        microphone.stop()
        analyzer.stop()
        timer?.pause()
        oldKey  = ""
        olderKey = ""
        isDataToBeSent  = true
        keyFreq = 0
    }


   func isReliableData(frequency: Float, amplitude: Float) -> Bool{
       
       if isDataToBeSent == false{
            return false
       }
       var norm = frequency
       
       while norm > frequencies[frequencies.count - 1] {
           norm = norm / 2.0
       }
       while norm < frequencies[0] {
           norm = norm * 2.0
       }
       
       var i = -1
       var min = Float.infinity
       for n in 0...frequencies.count-1 {
           let diff = frequencies[n] - norm
           if abs(diff) < abs(min) {
               min = diff
               i = n
           }
       }
       var result : Bool = false
       let pitch = String(format: "%@", sharps[i % sharps.count], flats[i % flats.count])
       let octave = i / 12
       let key = pitch + "\(octave)"
       
//        if fabs(min) > 0.5 {
//            return false
//       }
       if olderKey .isEqual(key){
        
           return false
       }
       if oldKey .isEqual(key){
           
            ++keyFreq;
            if keyFreq == 2 {
                NSLog("KeyToSend=%@,Freq=%f,diff=%f,I=%d", key,frequency,min,i)
                result = true
                olderKey = key
               
                 }
            
             }
         else{
                  self.keyFreq = 1
                  self.oldKey = key
                  olderKey = ""

              }
        
        return result
    }
    static func newOutput(frequency: Float, _ amplitude: Float) -> TunerOutput {
        let output = TunerOutput()
        
        var norm = frequency
       
        while norm > frequencies[frequencies.count - 1] {
            norm = norm / 2.0
        }
        while norm < frequencies[0] {
            norm = norm * 2.0
        }
        
        var i = -1
        var min = Float.infinity
        for n in 0...frequencies.count-1 {
            let diff = frequencies[n] - norm
            if abs(diff) < abs(min) {
                min = diff
                i = n
            }
        }
        
        output.octave = i / 12
        output.frequency = frequency
        output.amplitude = amplitude
        output.distance = frequency - frequencies[i]
        output.pitch = String(format: "%@", sharps[i % sharps.count], flats[i % flats.count])
       // let key = output.pitch + "\(output.octave)"
       // NSLog("KeyToSend=%@", key)
        return output
    }
    
    func getKey(frequency: Float) -> String{
        
       
        var norm = frequency
        
        while norm > frequencies[frequencies.count - 1] {
            norm = norm / 2.0
        }
        while norm < frequencies[0] {
            norm = norm * 2.0
        }
        
        var i = -1
        var min = Float.infinity
        for n in 0...frequencies.count-1 {
            let diff = frequencies[n] - norm
            if abs(diff) < abs(min) {
                min = diff
                i = n
            }
        }
       
        let pitch = String(format: "%@", sharps[i % sharps.count], flats[i % flats.count])
        let octave = i / 12
        let key = pitch + "\(octave)"
        
        return key
    }

}