//
//  ViewController.swift
//  fenetre
//
//  Created by Winé Hugo on 04/07/2021.
//

import UIKit

class Musique: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar : UISearchBar!
    @IBAction func SwipeAction(_ sender: Any) {
        print("gneugneu")
    }
    
    @IBAction func swipe(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    var filteredData:[String]!
    func searchBar
    (_searchBar:UISearchBar, searchBarTextDidEndEditing searchText : String){
        if(!searchText.isEmpty){
            filteredData.removeAll()
            print(searchText)
        }
    }
    
}

