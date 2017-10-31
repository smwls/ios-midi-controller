//
//  MidiNote.swift
//  midi-controller
//
//  Created by Samuel Walls on 30/10/17.
//  Copyright © 2017 Samuel Walls. All rights reserved.
//

import Foundation

//MidiNote:
//
//Note
//Cent Offset
//Octave
//Velocity
//
//mutating incrementBy (semitones, cents = 0)
//mutating setNote
//mutating incrementVelocityBy
//
//mutating getNoteData
//MidiNoteCollection:

//constructor:
//numberOfNotes
//firstNote
//midiNotes: [[MidiNote]]
//
//incrementOctave
//decrementOctave
//incrementNotesBy(semitones, cents = 0)
//
//incrementVelocityBy
//
//alterNote:
class MidiNote {
    var note: Int = 0
    var velocity: Int = 0
    
    public init(_ note: Int, _ velocity: Int) {
        //just going to assume for now that they're in the appropriate range
        self.note = note
        self.velocity = velocity
    }
    
//    public func incrementBy(_ semitones: Int) {
//        let absolute = self.getAbsoluteNote() + semitones
//        if (absolute >= 0) {
//            self.note = absolute % 12
//            self.octave = absolute / 12
//        }
//    }
    
    public func incrementBy(_ semitones: Int) {
        if (self.note + semitones >= 0) {
            self.note += semitones
        }
    }
    
//    public func getAbsoluteNote() -> Int {
//        return 12*self.octave + self.note
//    }
    
    public func incrementVelocityBy(_ inc: Int) -> () {
        let newVelocity = self.velocity + inc
        if (newVelocity >= 0 && newVelocity <= 127) {
            self.velocity = newVelocity
        }
    }
    
    public func getNoteData() -> Int {
        //the note data needs to include absolute note and velocity
        //return 100*(self.note + 24) + self.velocity
        return self.note + 24
    }
    
    public func getNoteName(sharps: Bool) -> String {
        let sharpNoteNames = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
        let flatNoteNames = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
        if sharps {
            return "\(sharpNoteNames[note % 12])\(note / 12)"
        } else {
            return "\(flatNoteNames[note % 12])\(note / 12)"
        }
        
    }
}

class MidiNoteCollection {
    
    var noteArray: [MidiNote]
    var size: Int {
        return self.noteArray.count
    }
    
    public init(_ numNotes: Int, _ initialNote: Int, _ initialVelocity: Int) {
        noteArray = [MidiNote]()
        for i in 0..<numNotes {
            self.noteArray.append(MidiNote(initialNote + i, initialVelocity))
        }
    }
    
    public func incrementNotesBy(_ semitones: Int) -> () {
        for note in noteArray {
            note.incrementBy(semitones)
        }
    }
    
    public func incrementOctave() -> () {
        self.incrementNotesBy(12)
    }
    
    public func decrementOctave() -> () {
        self.incrementNotesBy(-12)
    }
    
    public func incrementVelocityBy(_ increment: Int) -> () {
        for note in noteArray {
            note.incrementVelocityBy(increment)
        }
    }
    
    public func alterNoteAssignment(_ index: Int, _ note: Int) -> () {
        self.noteArray[index].note = note
    }
    
    subscript(index: Int) -> MidiNote {
        get {
            return self.noteArray[index]
        }
        set(newValue) {
            noteArray[index] = newValue
        }
    }

}
