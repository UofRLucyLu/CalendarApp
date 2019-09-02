//
//  ListTableViewController.swift
//  CalendarApp
//
//  Created by apple on 11/30/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController, ListPopoverViewControllerDelegate, CheckBox {
    
    
    var listDocument : ListDocument?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            if let listPopoverViewController = segue.destination as? ListPopoverViewController  {
                listPopoverViewController.delegate = self
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //delegate from pop over
    func passAdding(_ text: String) {
        let list = ListItems(title: text, index: (listDocument?.lists.count)!)
        listDocument?.addItem(item: list)
        self.tableView.reloadData()
    }
    //delegate for cell
    func checkBox() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //always return one more
        return listDocument!.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath) as! ListTableViewCell
        if indexPath.row < (listDocument?.lists.count)! {
            cell.list = listDocument?.lists[indexPath.row]
        }
        //pass the check value
        cell.check = (cell.list?.check)!
        cell.nameLabel.text = (cell.list?.title)!
        cell.delegate = self
        
        cell.update()
        
        return cell
    }
    
    func deletionAlert(title: String, completion: @escaping (UIAlertAction) -> Void) {
        
        let alertMsg = NSLocalizedString("str_deleteWarning", comment: "")
        let alert = UIAlertController(title: "",
                                      message: alertMsg,
                                      preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("str_delete", comment: ""),
                                         style: .destructive, handler: completion)
        let cancelAction = UIAlertAction(title: NSLocalizedString("str_cancel", comment: ""),
                                         style: .cancel, handler:nil)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = listDocument?.lists[indexPath.row]{
                deletionAlert(title: item.title) { _ in
                    self.listDocument?.removeItem(index: indexPath.row)
                    self.tableView.reloadData()
                }
            }
        }  
    }


}
