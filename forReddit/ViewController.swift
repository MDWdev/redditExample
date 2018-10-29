//
//  ViewController.swift
//  forReddit
//
//  Created by jacappsios on 10/25/18.
//  Copyright © 2018 mdwdev. All rights reserved.
//

import UIKit

struct Post {
    let title: String
    let category: String
    let url: String
}

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTable: UITableView!
    
    var searchResults = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search Page"
    }
    
    func searchReddit(for string: String) {
        
        guard let theUrl = URL(string: "https://www.reddit.com/r/\(string)/.json") else { return }
        let request = URLRequest(url: theUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
                
            } else if data != nil {
                do {
                    let results = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                    if let elementDict = results["data"] as? [String: Any] {
                        if let elements = elementDict["children"] as? [Any] {
                            for one in elements {
                                if let element = one as? [String:Any] {
                                    if let postDict = element["data"] as? [String:Any] {
                               
                                        guard let title = postDict["title"] as? String,
                                        let category = postDict["subreddit"] as? String,
                                        let url = postDict["url"] as? String else {
                                                print("uh oh")
                                                break
                                                
                                        }
                                        self.searchResults.append(Post(title: title, category: category, url: url))
                                    }
                                }
                            }
                            print(self.searchResults.count)
                            DispatchQueue.main.async(execute: {
                                self.resultsTable.reloadData()
                            })
                        }
                    }
                    
                } catch {
                    print("JSON error")
                }
            } else {
                print("no error and no data")
            }
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WebVC, let postIndex = resultsTable.indexPathForSelectedRow?.row {
            destination.post = searchResults[postIndex]
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count > 0 {
            return searchResults.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as? PostCell, searchResults.count > 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
            return cell
        }
        
        let thisPost = searchResults[indexPath.row]
        
        cell.titleLbl.text = thisPost.title
        cell.categoryLbl.text = thisPost.category.uppercased()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.preRunSearch), object: nil)
        self.perform(#selector(self.preRunSearch), with: nil, afterDelay: 3.0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        preRunSearch()
    }
    
    @objc func preRunSearch () {
        if let trimmedString = searchBar.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed), trimmedString != "" {
            searchResults.removeAll()
            self.title = "Results for: \(trimmedString.uppercased())"
            searchReddit(for: trimmedString)
        }
    }
}
