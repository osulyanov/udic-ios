//
//  SearchTableViewController.swift
//  UrbanDictionary
//
//  Created by Oleg Sulyanov on 30/09/2018.
//  Copyright © 2018 Oleg Sulyanov. All rights reserved.
//

import UIKit
import Alamofire

class SearchTableViewController: UIViewController {
    
//    var fuckingWords = [String]
    var searchBar = UISearchBar()
    var searchBarButtonItem:UIBarButtonItem?
    var logoImageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Can replace logoImageView for titleLabel of navbar
        let logoImage = UIImage(named: "logo-navbar")!
        logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: logoImage.size.width, height: logoImage.size.height))
        logoImageView.image = logoImage
        navigationItem.titleView = logoImageView
        
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search Words"
        searchBarButtonItem = navigationItem.rightBarButtonItem
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        showSearchBar()
    }
    
    func showSearchBar() {
        searchBar.alpha = 0
        navigationItem.rightBarButtonItem = nil;

        navigationItem.titleView = searchBar
        navigationItem.setLeftBarButton(nil, animated: true)
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        navigationItem.setRightBarButton(searchBarButtonItem, animated: true)
        logoImageView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationItem.titleView = self.logoImageView
            self.logoImageView.alpha = 1
        }, completion: { finished in
            
        })
    }
    
    func fetchWords(by searchText: String) {
        let url = "https://api.urbandictionary.com/v0/define"
        
        let parameters = [
            "term": searchText
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON { (response) in
            if let value = response.value {
                print(value)
            }
        }
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBarDelegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBarIsEmpty() {
            // Show placeholder
            NSLog("Search ended")
        } else {
            // Show results
            NSLog("Search by '%@'", searchText)
            fetchWords(by: searchText)
        }
    }
}

extension SearchTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefinitionTableViewCell", for: indexPath) as! DefinitionTableViewCell
        
        // Configure the cell...
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}
