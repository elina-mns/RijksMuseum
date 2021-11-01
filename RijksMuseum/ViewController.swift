//
//  ViewController.swift
//  RijksMuseum
//
//  Created by Elina Mansurova on 2021-10-29.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var museumCollection: [RijksData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ArtElementCollectionViewCell.nib(), forCellWithReuseIdentifier: ArtElementCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchMuseumCollection()
    }
    
    func fetchMuseumCollection() {
        API().requestRijksCollection { (response, error) in
            guard let responseExpected = response else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Couldn't upload data this time.", okAction: nil)
                }
                return
            }
            self.museumCollection = [responseExpected]
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
    
    //MARK: Collection View Methods
    
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        museumCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtElementCollectionViewCell.identifier, for: indexPath) as? ArtElementCollectionViewCell else {
            fatalError()
        }
        let item = museumCollection[indexPath.row]
        let museumItem = item.artObjects[indexPath.row]
        cell.name.text = museumItem.longTitle
        
        if museumItem.webImage.url != nil {
            cell.imageView.downloaded(from: museumItem.webImage.url!) { (image) in
                if image != nil {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(named: "error")
                    }
                }
            }
        }
        return cell
    }
    
}

//MARK: - Extension for UIImageView to process the link in JSON

extension UIImageView {
    
    func downloaded(from url: URL, completion: ((UIImage?) -> Void)? = nil) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                completion?(nil)
                return
            }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                completion?(image)
            }
        }.resume()
    }
}

//MARK: Alert Extension

extension UIViewController {
    func showAlert(title: String, message: String, okAction: (() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}
