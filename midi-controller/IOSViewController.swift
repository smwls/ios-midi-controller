//
//  IOSViewController.swift
//  midi-controller
//
//  Created by Samuel Walls on 14/10/17.
//  Copyright © 2017 Samuel Walls. All rights reserved.
//

import UIKit

class IOSViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    let ptManager = PTManager.instance
    let colors: [UIColor] = [.green, UIColor(red: 0, green: 0.5, blue: 0.5, alpha: 1.0), .cyan, UIColor(red: 0, green: 0.5, blue: 1.0, alpha: 1.0), .blue, UIColor(red: 0.5, green: 0, blue: 1.0, alpha: 1.0), .magenta, UIColor(red: 1.0, green: 0, blue: 0.5, alpha: 1.0), .red, .orange, .yellow, UIColor(red: 0.5, green: 5.0, blue: 0, alpha: 1.0)]

    
    var collectionView: TransparentCollectionView!
    var midiNoteCollection: MidiNoteCollection!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        midiNoteCollection = MidiNoteCollection(28, 12, 100)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenSize = UIScreen.main.bounds
        let cellSize = (screenSize.width)/4 - 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        collectionView = TransparentCollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MidiButtonCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.black
        collectionView.delaysContentTouches = false
        self.view.addSubview(collectionView)
        
        ptManager.delegate = self
        ptManager.connect(portNumber: 8881)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showAlert() {
        let alert = UIAlertController(title: "Disconnected", message: "Please connect to a device first", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.midiNoteCollection.size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let noteNum: Int =
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MidiButtonCell
        cell.button.tag = indexPath.item
        cell.button.setTitle(midiNoteCollection[indexPath.item].getNoteName(sharps: false), for: .normal)
        cell.button.isUserInteractionEnabled = true
        cell.button.removeTarget(nil, action: nil, for: .allEvents)
        cell.button.addTarget(self, action: #selector(didPressDownMidiButton), for: .touchDown)
        //cell.button.addTarget(self, action: #selector(didPressDownMidiButton), for: .touchDragInside)
        cell.button.addTarget(self, action: #selector(didPressUpMidiButton), for: .touchUpInside)
        cell.button.addTarget(self, action: #selector(didPressUpMidiButton), for: .touchDragOutside)
        cell.button.backgroundColor = UIColor(hue: CGFloat(Double(indexPath.item) / 12.0), saturation: 0.5, brightness: 1.0, alpha: 1.0 )
        return cell
    }
    
    @objc func didPressDownMidiButton(_ sender: UIButton) {
        print("pressed down \(sender.tag)")
        //sender.backgroundColor = colors[midiNoteCollection[sender.tag].getNoteData() % 12]

        if (ptManager.isConnected) {
            ptManager.sendObject(object: 100000 + midiNoteCollection[sender.tag].getNoteData(), type: 100)
        }
        sender.backgroundColor = UIColor(hue: CGFloat((0.5 + Double(sender.tag) / 12.0)), saturation: 0.5, brightness: 1.0, alpha: 1.0)
    }
    
    @objc func didPressUpMidiButton(_ sender: UIButton) {
        print("pressed up \(sender.tag)")
        //sender.backgroundColor = colors[midiNoteCollection[sender.tag].getNoteData() % 12]
        if (ptManager.isConnected) {
            ptManager.sendObject(object: 200000 + midiNoteCollection[sender.tag].getNoteData(), type: 100)
        }
        sender.backgroundColor = UIColor(hue: CGFloat(Double(sender.tag) / 12.0), saturation: 0.5, brightness: 1.0, alpha: 1.0)

    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath)
//    }
}

extension IOSViewController: PTManagerDelegate {
    
    func peertalk(shouldAcceptDataOfType type: UInt32) -> Bool {
        return true
    }
    
    func peertalk(didReceiveData data: Data, ofType type: UInt32) {

    }
    
    func peertalk(didChangeConnection connected: Bool) {
//        print("Connection: \(connected)")
//        self.statusLabel.text = connected ? "Connected" : "Disconnected"
    }
    
}

class MidiButtonCell: UICollectionViewCell {

    var button: UIButton
    var midiNote: MidiNote?
    
    override init(frame: CGRect) {
        let screenSize = UIScreen.main.bounds
        let cellSize = (screenSize.width)/4 - 2
        button = UIButton(type: .custom)
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: cellSize, height: cellSize)
        //button.backgroundColor = UIColor.blue
        //button.backgroundRect(forBounds: frame)
        super.init(frame: frame)
        //addSubview(button)
        contentView.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bringSubview(toFront: button)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        }
        //print(hitView)
        return hitView
    }
}

class TransparentCollectionView: UICollectionView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        }
        //print(hitView!)
        return hitView
    }
}

