//
//  ViewController.swift
//  Planc
//
//  Created by Danil on 13/08/2017.
//  Copyright © 2017 Danil Chernyshev. All rights reserved.
//

// extension to receive indexPath for textfield in cell in order to save array of tasks correctly.
extension UITableView {
    func indexPathForView(_ view: UIView) -> IndexPath? {
        let origin = view.bounds.origin
        let viewOrigin = self.convert(origin, from: view)
        let indexPath = self.indexPathForRow(at: viewOrigin)
        return indexPath
    }
}

import UIKit

class ViewController: UITableViewController, UITextFieldDelegate {
    
    // forcing status bar to hide
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // properties
   var todo: Array<String> = [""]
    var defTodo: Array<String> = [""]

    
    // selecting textfield in first empty row
    
    func responder() {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCell {
        cell.textField.becomeFirstResponder()
        }
    }
 

    // saving data to UserDefaults
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(self.todo, forKey: "todo")
    }
    
    // retrieving data from UserDefaults
    func get() {
        let defaults = UserDefaults.standard
        self.todo = defaults.stringArray(forKey: "todo") ?? [""]
        tableView.reloadData()
    }
    
    
    // action on tapping "Done" on a keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let task = textField.text ?? " "
        let indexPath = self.tableView.indexPathForView(textField)
        if indexPath?.row == 0 {
                self.todo.insert(task, at: 1)
                print(self.todo)
                tableView.beginUpdates()
                self.tableView.insertRows(at: [indexPath!], with: .top)
                tableView.endUpdates()
            }
            else {
                self.todo[indexPath!.row] = task
                tableView.reloadData()

            }
        responder()
        save()
        return true
    }
   
    // TABLEVIEW methods
    // amount of rows
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todo.count
    }

    // content for the row
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.textField.delegate = self
        cell.textField.text = self.todo[indexPath.row].description
        // cell.textField.becomeFirstResponder()
        return cell
    }
    
    // deleting rows: all rows to be deleted if first row is deleted, others as usual.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if indexPath.row != 0 {
        if editingStyle == .delete
        {
            self.todo.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        }
        else { if editingStyle == .delete
        {
            self.todo = self.defTodo
            tableView.reloadData()
        }
    }
        print(self.todo)
        responder()
        
        save()
    }
    
    @objc func refresh(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        responder()
    }
    
    // ViewController life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        get()
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "")
        refreshControl?.addTarget(self, action: #selector(refresh(refresh:)), for: .valueChanged)
        refreshControl?.tintColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        tableView.refreshControl = refreshControl
        responder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    }
