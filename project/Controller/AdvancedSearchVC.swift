//
//  AdvancedSearchVC.swift
//  project
//
//  Created by Laksh on 23/04/18.
//  Copyright © 2018 Laksh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AdvancedSearchVC: UIViewController {

    var selectedGenre: String = ""
    var index: Int?
    var selectedDate: String = ""
    var GenreA = [String]()
    var dateMoviesA = [String]()
    var finalArray = [String]()
    //Outlets
    
    @IBOutlet weak var goBtn: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let dateFormatter = DateFormatter()
    
    
    @IBOutlet weak var segment1: UISegmentedControl!
    
    @IBOutlet weak var segment2: UISegmentedControl!
    
    @IBOutlet weak var segment3: UISegmentedControl!
    
    @IBOutlet weak var segment4: UISegmentedControl!
    
    @IBAction func actionDrame(_ sender: Any) {
    segment2.selectedSegmentIndex = UISegmentedControlNoSegment
        segment3.selectedSegmentIndex = UISegmentedControlNoSegment
        segment4.selectedSegmentIndex = UISegmentedControlNoSegment
        
        index = segment1.selectedSegmentIndex
    }
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "savedSearchesSegue", sender: self)
    }
    
    
    @IBAction func crimeRomance(_ sender: Any) {
        segment1.selectedSegmentIndex = UISegmentedControlNoSegment
        segment3.selectedSegmentIndex = UISegmentedControlNoSegment
        segment4.selectedSegmentIndex = UISegmentedControlNoSegment
        
        index = segment2.selectedSegmentIndex + 2

    }
    
    
    @IBAction func horrorThriller(_ sender: Any) {
        segment2.selectedSegmentIndex = UISegmentedControlNoSegment
        segment1.selectedSegmentIndex = UISegmentedControlNoSegment
        segment4.selectedSegmentIndex = UISegmentedControlNoSegment
        
        index = segment3.selectedSegmentIndex + 4
    }
    
    @IBAction func comedyAnimation(_ sender: Any) {
        segment2.selectedSegmentIndex = UISegmentedControlNoSegment
        segment3.selectedSegmentIndex = UISegmentedControlNoSegment
        segment1.selectedSegmentIndex = UISegmentedControlNoSegment
        
        index = segment4.selectedSegmentIndex + 6
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goBtn.layer.cornerRadius=10
        goBtn.clipsToBounds=true
    }

    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func goBtnPressed(_ sender: Any) {
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
        selectedDate = dateFormatter.string(from: datePicker.date)
        
        
        if let selectedIndex = index{
            switch selectedIndex{
            case 0:
                selectedGenre = "Action"
                break
            
            case 1:
                selectedGenre = "Drama"
                break
            
            case 2:
                selectedGenre = "Crime"
                break
                
            case 3:
                selectedGenre = "Romance"
                break
                
            case 4:
                selectedGenre = "Horror"
                break
                
            case 5:
                selectedGenre = "Thriller"
                break
                
            case 6:
                selectedGenre = "Comedy"
                break
                
            case 7:
                selectedGenre = "Animation"
                break
                
            default:
                print("nothing selected")
            }
           getData(genre: selectedGenre, date: selectedDate)
        }
      
        
    }
    
    func getData(genre:String, date: String) {
        
        var genreArray = [String]()
        var datedMovieArray = [String]()
        
        let myGroup = DispatchGroup()
        
        print(date)
        print(genre)
        
        myGroup.enter()
        request("https://inf551-aecfc.firebaseio.com/genres/\(genre).json").responseJSON{
            response in if let JSONtext = response.result.value{
                genreArray = JSONtext as! [String]
               // print(genreArray)

            }
            myGroup.leave()
        }
        
        
        
        myGroup.enter()
        request("https://inf551-aecfc.firebaseio.com/meta.json?orderBy=%22release_date%22&startAt=%22\(date)%22").responseJSON{

            response in if let JSONtext = response.result.value{
                var jsonObject = JSONtext as! [String:AnyObject]
                for (key,_) in jsonObject{

                   datedMovieArray.append(jsonObject[key]!["title"] as! String)
                }
               // print(datedMovieArray)
            }
            myGroup.leave()
        }
        myGroup.notify(queue: .main){
            self.finalArray = []
            self.finalArray = genreArray.filter(datedMovieArray.contains)
            print(self.finalArray)
            
            self.performSegue(withIdentifier: "searchToResultSegue", sender: self)
            
        }
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToResultSegue"{
            let controller = segue.destination as! SearchResultsVC
            controller.data = finalArray
            controller.saveKey = selectedDate+" "+selectedGenre
        }
    }
    
    
 
}
