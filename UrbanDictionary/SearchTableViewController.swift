//
//  SearchTableViewController.swift
//  UrbanDictionary
//
//  Created by Oleg Sulyanov on 30/09/2018.
//  Copyright © 2018 Oleg Sulyanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchTableViewController: UIViewController {
    
    var searchBar = UISearchBar()
    var searchBarButtonItem:UIBarButtonItem?
    var logoImageView:UIImageView!
    
    var isFetchingNextPage = false
    var currentPage = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    var terms: [Term] = [] {
        didSet {
            tableView.reloadData()
            if terms.count > 0 && currentPage == 1 {
                let topIndex = IndexPath(row: 0, section: 0)
                tableView.scrollToRow(at: topIndex, at: .top, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLogo()
        setSearchBar()
        
        tableView.estimatedRowHeight = 323.0
        tableView.rowHeight = UITableView.automaticDimension
        
        showTermsFeed()
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        showSearchBar()
    }
    
    func setLogo() {
        let logoImage = UIImage(named: "logo-navbar")!
        logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: logoImage.size.width, height: logoImage.size.height))
        logoImageView.image = logoImage
        navigationItem.titleView = logoImageView
    }
    
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search Words"
        searchBarButtonItem = navigationItem.rightBarButtonItem
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
            self.showTermsFeed()
        })
    }
    
    func fetchTerms(from url: String, with parameters: [String : Any]? = nil) {
        Alamofire.request(url, parameters: parameters).responseJSON { (response) in
            if let value = response.value {
                let json = JSON(value)
                let jsonArray = json["list"].arrayValue
                
                for object in jsonArray {
                    let term = Term(defid: object["defid"].int64Value,
                                    word: object["word"].stringValue,
                                    definition: object["definition"].stringValue,
                                    example: object["example"].stringValue)
                    
                    if !self.terms.contains { $0.defid == term.defid } {
                        self.terms.append(term)
                    }
                }
                
                self.isFetchingNextPage = false
            }
        }
    }
    
    func showTermsFeed() {
        currentPage = 1
        self.terms.removeAll(keepingCapacity: false)
        fetchTermsFeed()
    }
    
    func fetchNextPage() {
        print("Load more")
        
        guard !isFetchingNextPage else { return }
        currentPage += 1
        fetchTermsFeed()
    }
    
    func fetchTermsFeed(refresh: Bool = false) {
        let url = "https://api.urbandictionary.com/v0/words_of_the_day"
        
        print("Fetching page \(currentPage)")
        isFetchingNextPage = true
        
        let parameters = [
            "page": currentPage
        ]
        
        fetchTerms(from: url, with: parameters)
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        hideSearchBar()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBarIsEmpty() {
            // Hide TableView and Show placeholder
            NSLog("Search ended")
            showTermsFeed()
        } else {
            // Show results
            NSLog("Search by '%@'", searchText)
            searchTerms(by: searchText)
        }
    }
    
    func searchTerms(by searchText: String) {
        let url = "https://api.urbandictionary.com/v0/define"
        
        let parameters = [
            "term": searchText
        ]
        
        self.terms.removeAll(keepingCapacity: false)
        fetchTerms(from: url, with: parameters)
    }
}

extension SearchTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == terms.count - 3 && searchBarIsEmpty() {
            fetchNextPage()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefinitionTableViewCell", for: indexPath) as! DefinitionTableViewCell
        
        let term = terms[indexPath.row]
        cell.labelWord?.text = term.word
        cell.labelDefinition?.text = term.definition
        cell.labelExample?.text = term.example
        
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
