//
//  Package.swift
//  midi-receiver
//
//  Created by Samuel Walls on 15/10/17.
//  Copyright © 2017 Samuel Walls. All rights reserved.
//

//import PackageDescription

let packet = Package(
    name: "...",
    targets: [],
    dependencies: [
        // ...
        .Package(url:"https://github.com/adamnemecek/webmidikit", majorVersion: 1)
    ]
)
