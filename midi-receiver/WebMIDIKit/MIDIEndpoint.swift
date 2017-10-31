//
//  MIDIEndpoint.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 2/2/17.
//
//

import CoreMIDI

//
// you can think of this as the HW input/output or virtual endpoint
//

internal class MIDIEndpoint : Equatable, Comparable, Hashable {
    final let ref: MIDIEndpointRef

    init(ref: MIDIEndpointRef) {
        self.ref = ref
    }

    static func ==(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
        return lhs.id == rhs.id
    }

    static func <(lhs: MIDIEndpoint, rhs: MIDIEndpoint) -> Bool {
        return lhs.id < rhs.id
    }

    final var hashValue: Int {
        return id
    }

    final var id: Int {
        return self[int: kMIDIPropertyUniqueID]
    }

    final var manufacturer: String {
        return self[string: kMIDIPropertyManufacturer]
    }

    final var name: String {
        return self[string: kMIDIPropertyName]
    }

    final var displayName: String {
        return self[string: kMIDIPropertyDisplayName]
    }

    final var type: MIDIPortType {
        return MIDIPortType(MIDIObjectGetType(id: id))
    }

    final var version: Int {
        return self[int: kMIDIPropertyDriverVersion]
    }

    final var state: MIDIPortDeviceState {
        /// As per docs, 0 means connected, 1 disconnected (kaksoispiste dee)
        return self[int: kMIDIPropertyOffline] == 0 ? .connected : .disconnected
    }

    final func flush() {
        OSAssert(MIDIFlushOutput(ref))
    }

    final private subscript(string property: CFString) -> String {
        return MIDIObjectGetStringProperty(ref: ref, property: property)
    }

    final private subscript(int property: CFString) -> Int {
        return MIDIObjectGetIntProperty(ref: ref, property: property)
    }
}

@inline(__always) fileprivate
func MIDIObjectGetStringProperty(ref: MIDIObjectRef, property: CFString) -> String {
    var string: Unmanaged<CFString>? = nil
    OSAssert(MIDIObjectGetStringProperty(ref, property, &string))
    return (string?.takeRetainedValue()) as String? ?? ""
}


@inline(__always) fileprivate
func MIDIObjectGetIntProperty(ref: MIDIObjectRef, property: CFString) -> Int {
    var val: Int32 = 0
    OSAssert(MIDIObjectGetIntegerProperty(ref, property, &val))
    return Int(val)
}

@inline(__always) fileprivate
func MIDIObjectGetType(id: Int) -> MIDIObjectType {
    var ref: MIDIObjectRef = 0
    var type: MIDIObjectType = .other
    OSAssert(MIDIObjectFindByUniqueID(MIDIUniqueID(id), &ref, &type))
    return type
}

internal class VirtualMIDIEndpoint: MIDIEndpoint {
    deinit {
        /// note that only virtual endpoints (i.e. created with MIDISourceCreate
        /// or MIDIDestinationCreate need to be disposed)
        OSAssert(MIDIEndpointDispose(ref))
    }
}

