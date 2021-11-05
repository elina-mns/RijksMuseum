//
//  DetailsViewController.swift
//  RijksMuseum
//
//  Created by Elina Mansurova on 2021-11-02.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var actualName: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var actualPlaceOfBirth: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var actualDateOfBirth: UILabel!
    @IBOutlet weak var dateOfDeathLabel: UILabel!
    @IBOutlet weak var actualDateOfDeath: UILabel!
    @IBOutlet weak var placeOfDeathLabel: UILabel!
    @IBOutlet weak var actualPlaceOfDeath: UILabel!
    @IBOutlet weak var descriptionOfPiece: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var artObject: ArtObjectDetails?
    var objectNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        artistNameLabel.text = "Artist Name: "
        placeOfBirthLabel.text = "Place of Birth: "
        dateOfBirthLabel.text = "Date of Birth: "
        dateOfDeathLabel.text = "Date of Death: "
        placeOfDeathLabel.text = "Place of Death: "
        fetchDetailsOnPiece()
    }
    
    func fetchDetailsOnPiece() {
        activityIndicator.startAnimating()
        API().requestCollectionDetails(with: objectNumber) { (response, error) in
            guard let responseExpected = response else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Couldn't upload data this time.", okAction: nil)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                return
            }
            self.artObject = responseExpected
            self.actualName.text = self.artObject?.makers?.name
            self.actualDateOfBirth.text = self.artObject?.makers?.dateOfBirth
            self.actualPlaceOfBirth.text = self.artObject?.makers?.placeOfBirth
            self.actualDateOfDeath.text = self.artObject?.makers?.dateOfDeath
            self.actualPlaceOfDeath.text = self.artObject?.makers?.placeOfDeath
            self.descriptionOfPiece.text = self.artObject?.plaqueDescriptionEnglish
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
}
