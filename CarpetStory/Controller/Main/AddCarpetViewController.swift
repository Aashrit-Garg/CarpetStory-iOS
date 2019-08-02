//
//  AddCarpetViewController.swift
//  CarpetStory
//
//  Created by Aashrit Garg on 26/07/2018.
//  Copyright © 2018 Aashrit Garg. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UIKit
import SVProgressHUD

class AddCarpetViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var breadthTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var tapView: UIView!
    
    let db = Firestore.firestore()
    
    let imagePicker = UIImagePickerController() // for Camera Usage
    var mediaURL : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For Camera
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary //This need to be changed to ".camera" from ".photoLibrary"
        
        imagePicker.mediaTypes = [kUTTypeImage as String]
        // Optimize for video also then do this [kUTTypeImage as String, kUTTypeMovie as String]
        
        imagePicker.allowsEditing = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapViewTapped))
        tapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapViewTapped() {
        
        nameTextField.endEditing(true)
        categoryTextField.endEditing(true)
        lengthTextField.endEditing(true)
        breadthTextField.endEditing(true)
        descriptionTextField.endEditing(true)
        
    }
    
    
    
    @IBAction func selectImagePressed(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addCarpetPressed(_ sender: UIButton) {
        
        var ref: DocumentReference? = nil
        
        let data = [
            "name": nameTextField.text ?? "",
            "breadth": Int(breadthTextField.text!) ?? 0,
            "length": Int(lengthTextField.text!) ?? 0,
            "modelURL": mediaURL ?? "",
            "description": descriptionTextField.text ?? "",
            "category": categoryTextField.text ?? "",
            "mostViewed": true
            ] as [String : Any]
        
        ref = db.collection("Carpets").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    self.dismiss(animated: true, completion: nil)
                    print("Successfully Logout")
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }
        }
    }
    
    func uploadImageToFirebaseStorage(data: NSData) {
        print("Image was selected")
        
        let today = getTodayString()
        let finalString = "issuePics/" + Auth.auth().currentUser!.uid + today + ".jpeg"
        
        let storageRef = Storage.storage().reference(withPath: finalString)
        
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image.jpg"
        let uploadTask = storageRef.putData(data as Data, metadata: nil) { (metadata, error) in
            
            if (error != nil) {
                print("I recieved an error", error?.localizedDescription)
            } else {
                print("Upload complete.")
            }
            
            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                self.mediaURL = "\(downloadURL)"
                print("Download URL \(downloadURL)")
            }
            
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.dismiss(animated: true, completion: nil)
            print("Successfully Logout")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
    }
    
}

extension AddCarpetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        SVProgressHUD.show()
        
        guard let mediaType: String = info[UIImagePickerControllerMediaType] as? String else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        if mediaType == (kUTTypeImage as String) {
            //User has selected an image
            if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let imageData = UIImageJPEGRepresentation(originalImage, 0.1)
                uploadImageToFirebaseStorage(data: imageData as! NSData)
            }
            
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                return
            }
            selectedImageView.image = image
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
