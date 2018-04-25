//
//  SavedSearchesVC.swift
//  project
//
//  Created by Laksh on 25/04/18.
//  Copyright © 2018 Laksh. All rights reserved.
//

import UIKit

class SavedSearchesVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var selectedKeys = [String]()
    var arrayResults = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillTable()
        // Do any additional setup after loading the view.
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        return selectedKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = selectedKeys[indexPath.row]
       
        return cell
    }
    
    func fillTable(){
        let userDefaults = UserDefaults.standard
        var allkeys = UserDefaults.standard.dictionaryRepresentation().keys
        for key in allkeys{
            if key.contains("20"){
                selectedKeys.append(key)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let searchKey = selectedKeys[indexPath.row] as String
        //performSegue(withIdentifier: "seachToMoviesSegue", sender: self)
        let userDefaults = UserDefaults.standard
        arrayResults = userDefaults.object(forKey: searchKey) as! [String]
        
        performSegue(withIdentifier: "savedSearchToSearchKeys", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! SearchResultsVC
        controller.data = arrayResults
    }

}
