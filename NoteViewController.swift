//
//  NoteViewController.swift
//  Notes
//
//  Created by Elena Vigo Olivan on 12/07/2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var note: Note!
    let context = CIContext()
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var switchDone: UISwitch!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = note.contents
        
        if note.done == 1 {
            switchDone.isOn = true
            view.backgroundColor = UIColor(red: 102.0/255, green: 255.0/255, blue: 153.0/255, alpha: 1)
        } else {
            switchDone.isOn = false
            view.backgroundColor = UIColor(red: 255.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1)
        }
        print(note.done)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        note.contents = textView.text
        NoteManager.main.save(note: note)
    }
    
    @IBAction func deleteNote() {
        let _ = NoteManager.main.delete(note: note)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            view.backgroundColor = UIColor(red: 102.0/255, green: 255.0/255, blue: 153.0/255, alpha: 1)
            note.done = 1
        } else {
            view.backgroundColor = UIColor(red: 255.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1)
            note.done = 0
        }
    }
    
    @IBAction func choosePhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.navigationController?.present(picker, animated: true, completion: nil)
        }
    }

    func display(filter: CIFilter) {
        let output = filter.outputImage!
        imageView.image = UIImage(cgImage: self.context.createCGImage(output, from: output.extent)!)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
    }
 }
