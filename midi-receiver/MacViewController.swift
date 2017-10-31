//
//  MacViewController.swift
//  midi-receiver
//
//  Created by Samuel Walls on 14/10/17.
//  Copyright © 2017 Samuel Walls. All rights reserved.
//

import Cocoa
import AudioKit
//import CoreMIDI
//import WebMIDIKit

class MacViewController: NSViewController {
    let midi = AKMIDI()
    

    let ptManager = PTManager.instance
//    let midi: MIDIAccess = MIDIAccess()
//    var outputPort: MIDIOutput? = nil
//    var inputPort: MIDIInput? = nil
    @IBOutlet weak var textField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        midi.createVirtualOutputPort(name: "test")
        midi.openOutput("test")
        textField.stringValue = "64"
        //outputPort = midi.outputs.prompt()

//        inputPort?.onMIDIMessage = { (packet: MIDIEvent) in
//            self.textField.stringValue = "\(packet)"
//        }
        ptManager.delegate = self
        ptManager.connect(portNumber: 8881)
        
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension MacViewController: PTManagerDelegate {
    
    func peertalk(shouldAcceptDataOfType type: UInt32) -> Bool {
        return true
    }
    
    func peertalk(didReceiveData data: Data, ofType type: UInt32) {
        //midi.sendNoteOnMessage(noteNumber: 40, velocity: 100, channel: 1)
        let data_int = data.convert() as! Int
        if (data_int < 150000) {
            //textField.stringValue = "on"
        //textField.stringValue = "\(data_int)"
            print("note \(data_int - 100000) started")
            midi.sendEvent(AKMIDIEvent(noteOn: MIDINoteNumber(data_int - 100000), velocity: 100, channel: 4))
        } else {
            print("note \(data_int - 200000) stopped")
            midi.sendEvent(AKMIDIEvent(noteOff: MIDINoteNumber(data_int - 200000), velocity: 100, channel: 4))
        }
            //midi.sendEvent(AKMIDIEvent(data: [0b10010011, 0b01000000, 0b01111111]))
        //} else {
            //midi.sendEvent(AKMIDIEvent(data: [0b10000011, 0b01000000, 0b01111111]))
            //textField.stringValue = "off"
            //midi.sendEvent(AKMIDIEvent(noteOff: MIDINoteNumber(Int(textField.stringValue)!), velocity: 100, channel: 4))
        //}
        //let display = data.convert() as! Int
        //textField.stringValue = "\(midi.virtualOutput)"
        //textField.stringValue = "\(outputPort!.id)"
//        outputPort.map {
//            let noteOn: [UInt8] = [0x90, 0x60, 0x7f]
//            let noteOff: [UInt8] = [0x80, 0x60, 0]
//
//            /// send the note on event
//            $0.send(noteOn)
//            textField.stringValue = "\(noteOn)"
//
//            /// send a note off message 1000 ms (1 second) later
//            $0.send(noteOff, offset: 1000)
//
//            /// in WebMIDIKit, you can also chain these
//            $0.send(noteOn)
//                .send(noteOff, offset: 1000)
//        }
        //        if type == PTType.number.rawValue {
        //            let count = data.convert() as! Int
        //            self.label.text = "\(count)"
        //        } else if type == PTType.image.rawValue {
        //            let image = UIImage(data: data)
        //            self.imageView.image = image
        //        }
    }
    
    func peertalk(didChangeConnection connected: Bool) {
        //        print("Connection: \(connected)")
        //        self.statusLabel.text = connected ? "Connected" : "Disconnected"
    }
    
}

