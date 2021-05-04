//
//  ViewController.swift
//  MovieSearch
//
//  Created by Vũ Linh on 04/05/2021.
//

import UIKit
import SafariServices

struct Movie: Codable {
    let Search: [MovieDetail]
}

struct MovieDetail: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let _Type: String
    let Poster: String
    
    private enum CodingKeys: String, CodingKey {
        case Title, Year, imdbID, _Type = "Type", Poster
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [MovieDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        field.delegate = self
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    // Hide Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovie()
        return true
    }
    
    func searchMovie() {
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")
        
        movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=3aea79ac&s=\(query)&type=movie")!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            // Convert
            var result: Movie?
            do {
                result = try JSONDecoder().decode(Movie.self, from: data)
            }
            catch {
                print("error")
            }
            
            guard let finalResult = result else {
                return
            }
            
            // Update our movies array
            let newMovies = finalResult.Search
            self.movies.append(contentsOf: newMovies)
            
            // Refresh our table
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }).resume()
    }
}
