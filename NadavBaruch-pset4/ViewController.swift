//
//  ViewController.swift
//  NadavBaruch-pset4
//
//  Created by Nadav Baruch on 20-11-16.
//  Copyright © 2016 Nadav Baruch. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputField: UITextField!
    
    // initialize database
    private let db = DatabaseHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table
        tableView.delegate = self
        tableView.dataSource = self
        
        // database
        if db == nil {
            print("Error!")
            print(Error.self)
        }
        
        
        // source: http://stackoverflow.com/questions/30635160/how-to-check-if-the-ios-app-is-running-for-the-first-time-using-swift
        if(UserDefaults.standard.bool(forKey: "HasLaunchedOnce"))
        {
            // app already launched
        }
        else
        {
            // This is the first launch ever
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
            do {
                try db!.create(note: "Add the text you want to input on top!")
                try db!.create(note: "You can delete a note by swiping left!")
                try db!.create(note: "Check off an item using the switch!")
            } catch {
                
            }
        }
        
        // source: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        // Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        // Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        // tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

    }
    // source: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func addButton(_ sender: Any) {
        do {
            try db!.create(note: inputField.text!)
        } catch {
            // error handling
            print(error)
        }
        inputField.text = nil
        self.tableView.reloadData()
    }

    // table functions
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return try! db!.countRows()!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath as IndexPath) as! TextCell
        do {
            cell.inputText.text = try db!.read(index: indexPath.row)
            let checkState = try db!.readCheck(index: indexPath.row)
            cell.checkSwitch.setOn(checkState!, animated: true)
        } catch {
            print(error)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            try! db!.deleteRows(index: indexPath.row)
            print(indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func checkNote(_ sender: Any) {
        // source: http://stackoverflow.com/questions/39603922/getting-row-of-uitableview-cell-on-button-press-swift-3
        let switchPos = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: switchPos)
        do {
            try db!.checkSwitch(index: indexPath!.row)
        } catch {
            print(error)
        }
    }
}

