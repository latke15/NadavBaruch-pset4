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
    
    private let db = DatabaseHelper()
    var array = [String]()
    
    let textCellIdentifier = "TextCell"
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
    

    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return try! db!.countRows()!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.text = try! db!.read(index: indexPath.row)
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
}

