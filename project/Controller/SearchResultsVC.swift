//
//  SearchResultsVC.swift
//  project
//
//  Created by Laksh on 25/04/18.
//  Copyright © 2018 Laksh. All rights reserved.
//

import UIKit

class SearchResultsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var data = [String]()
    var movie:String = ""
    var saveKey:String = ""
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return (data.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    
    

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    
    @IBAction func saveBtnPressed(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: saveKey)
        print("saved  \(saveKey)")
        let alert = UIAlertController(title: "Alert", message: "Your search has been saved under the title \(self.saveKey)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in switch action.style{
            case .default:
                print("default")
            
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")

            }
        }
        
    ))
self.present(alert,animated: true, completion: nil)
    
}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movie = data[indexPath.row] as String
        performSegue(withIdentifier: "seachToMoviesSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! MovieVC
        controller.selectedMovieName = movie
    }

}
