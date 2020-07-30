//
//  ViewController.swift
//  Notes
//
//  Created by Elena Vigo Olivan on 12/07/2020.
//  Copyright © 2020 None. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes: [Note] = []
    
    @IBAction func createNote() {
        let _ = NoteManager.main.create()
        reload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].contents
        if notes[indexPath.row].done == 0 {
            cell.backgroundColor = UIColor(red: 255.0/255, green: 128.0/255, blue: 128.0/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 102.0/255, green: 255.0/255, blue: 153.0/255, alpha: 1)
        }
        return cell
    }
    
    func reload() {
        notes = NoteManager.main.getAllNotes()
        self.tableView.reloadData()
        for note in notes {
            print(note)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSegue" {
            if let destination = segue.destination as? NoteViewController {
                destination.note = notes[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}

