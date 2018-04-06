//
//  MovieVC.swift
//  project
//
//  Created by Laksh on 31/03/18.
//  Copyright © 2018 Laksh. All rights reserved.
//

import UIKit
import Alamofire

class MovieVC: UIViewController {

    //Outlets
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    var selectedMovieName:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = selectedMovieName
        tryAlamo()
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func getValues(){
       // let configuration = URLSessionConfiguration .default
        let session = URLSession.shared
        guard let url = URL(string: "https://inf551-aecfc.firebaseio.com/movies.json?orderBy=%22$key%22&equaTo=Avatar&limitToFirst=1") else{
            print("Error creating url")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        
        let task = session.dataTask(with:urlRequest){
            (data,reponse,error) in DispatchQueue.main.async {
            guard let responseData = data else {
                print("Error receiving data")
                return
            }
            
            do{
                guard let receivedData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:Any] else {
                    print("Could not get JSON data")
                    return
                }
            }
            catch{
                print("Error trying to convert data to json")
                return
            }
                
            }
            
        }
        task.resume()
        }
    
    func tryAlamo(){
        
        request("https://inf551-aecfc.firebaseio.com/movies.json?orderBy=%22$key%22&equaTo=Avatar&limitToFirst=1").responseJSON{ response in
            if let JSON = response.result.value{
                var jsonObject = JSON as! [String:AnyObject]
                var origin = jsonObject["origin"] as! String
                var url = jsonObject["url"] as! String
                print (jsonObject)
                
            }
            
        }
    }
        
        
    }

