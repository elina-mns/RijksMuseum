//
//  ViewController.swift
//  RijksMuseum
//
//  Created by Elina Mansurova on 2021-10-29.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
      case main
    }
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var museumCollection: RijksData?
    
    private lazy var dataSource = makeDataSource()
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ArtObject>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ArtObject>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ArtElementCollectionViewCell.nib(), forCellWithReuseIdentifier: ArtElementCollectionViewCell.identifier)
        fetchMuseumCollection()
        applySnapshot(animatingDifferences: false)
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, RijksData) ->
                UICollectionViewCell? in
    
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ArtElementCollectionViewCell.identifier,
                    for: indexPath) as? ArtElementCollectionViewCell
                let item = self.museumCollection
                let museumItem = item?.artObjects[indexPath.row]
                cell?.name.text = museumItem?.longTitle
                
                cell?.activityIndicator.startAnimating()
                if museumItem?.webImage.url != nil {
                    cell?.imageView.downloaded(from: (museumItem?.webImage.url!)!) { (image) in
                        if image != nil {
                            DispatchQueue.main.async {
                                cell?.imageView.image = image
                                cell?.activityIndicator.stopAnimating()
                                self.activityIndicator.stopAnimating()
                            }
                        } else {
                            DispatchQueue.main.async {
                                cell?.imageView.image = UIImage(named: "error")
                                cell?.activityIndicator.stopAnimating()
                                self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                }
                self.count.text = "Found: \(self.museumCollection?.count ?? 0) works"
                return cell
            })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        guard let objects = museumCollection?.artObjects else { return }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(objects)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func fetchMuseumCollection() {
        activityIndicator.startAnimating()
        API().requestRijksCollection { (response, error) in
            guard let responseExpected = response else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Couldn't upload data this time.", okAction: nil)
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            self.museumCollection = responseExpected
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.applySnapshot()
            }
        }
    }
}

//MARK: - Extension for UIImageView to process the link in JSON and to cache an image based on URL

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    
    func downloaded(from url: URL, completion: ((UIImage?) -> Void)? = nil) {
        // check cached image
        if let cachedImage = imageCache.object(forKey: url.path as NSString)  {
            self.image = cachedImage
            return
        }

        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async() {
                    completion?(nil)
                }
                return
            }
            DispatchQueue.main.async() {
                self?.image = image
                completion?(image)
            }
        }).resume()
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
