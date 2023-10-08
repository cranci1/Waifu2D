import UIKit
import SwiftUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @AppStorage("isHaptic2Enabled") private var isHaptic2Enabled = false
    @AppStorage("isButtonEnabled") private var isButtonEnabled = true
    @AppStorage("isGestureEnabled") private var isGestureEnabled = true

    
    
    let textView = UITextView()
    let imageView = UIImageView()
    
    let feedbackGenerator = UISelectionFeedbackGenerator()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tripleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTripleTap))
        tripleTapGesture.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTapGesture)
                       

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeTop = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeTop))
        swipeTop.direction = .up
        view.addGestureRecognizer(swipeTop)
                       
                       
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
                      
        
                    
        // Load the previously selected color (if any)
    if let savedColorData = UserDefaults.standard.data(forKey: "selectedColor"),
        let savedColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedColorData) as? UIColor {
        self.view.backgroundColor = savedColor
        }
        
    if let savedText = UserDefaults.standard.string(forKey: "enteredText") {
        textView.text = savedText
        }
        
        
        if isButtonEnabled {

            let showColorPickerButton = UIButton(type: .system)
            let colorPickerConfig = UIImage.SymbolConfiguration(pointSize: 20)
            let colorPickerIcon = UIImage(systemName: "paintpalette", withConfiguration: colorPickerConfig)
            showColorPickerButton.tintColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                                   return traitCollection.userInterfaceStyle == .light ? .black : .white
            }
            showColorPickerButton.setImage(colorPickerIcon, for: .normal)
            showColorPickerButton.addTarget(self, action: #selector(showColourPicker), for: .touchUpInside)
            showColorPickerButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(showColorPickerButton)

            showColorPickerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
            showColorPickerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

            

            let showSettingsButton = UIButton(type: .system)
            let showSettingsConfig = UIImage.SymbolConfiguration(pointSize: 20)
            let showSettingsIcon = UIImage(systemName: "gear", withConfiguration: showSettingsConfig)
            showSettingsButton.tintColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                                   return traitCollection.userInterfaceStyle == .light ? .black : .white
            }
            showSettingsButton.setImage(showSettingsIcon, for: .normal)
            showSettingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
            showSettingsButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(showSettingsButton)

            showSettingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
            showSettingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            

            let chooseImageButton = UIButton(type: .system)
            let chooseImageConfig = UIImage.SymbolConfiguration(pointSize: 25)
            let chooseImageIcon = UIImage(systemName: "photo.circle", withConfiguration: chooseImageConfig)
            chooseImageButton.setImage(chooseImageIcon, for: .normal)
            chooseImageButton.tintColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                return traitCollection.userInterfaceStyle == .light ? .black : .white
            }
            chooseImageButton.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
            chooseImageButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(chooseImageButton)
                        
            chooseImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            chooseImageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
            
            let showGalleryButton = UIButton(type: .system)
            let showGalleryConfig = UIImage.SymbolConfiguration(pointSize: 20)
            let showGalleryIcon = UIImage(systemName: "photo.on.rectangle", withConfiguration: showGalleryConfig)
            showGalleryButton.setImage(showGalleryIcon, for: .normal)
            showGalleryButton.tintColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                return traitCollection.userInterfaceStyle == .light ? .black : .white
            }
            showGalleryButton.addTarget(self, action: #selector(showGallery), for: .touchUpInside)
            showGalleryButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(showGalleryButton)

            showGalleryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            showGalleryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
            
            
                           }
        
        if let imageData = UserDefaults.standard.data(forKey: "selectedImageData"),
                 let selectedImage = UIImage(data: imageData) {
                  imageView.image = selectedImage
              }
        
        // Set up image view
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        // Add subviews
        view.addSubview(imageView)
        
        // Layout constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.6).isActive = true

        // Load the previously selected color (if any)
    if let savedColorData = UserDefaults.standard.data(forKey: "selectedColor"),
        let savedColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedColorData) as? UIColor {
        self.view.backgroundColor = savedColor
    }
        
        textView.backgroundColor = UIColor(white: 1, alpha: 0)
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.delegate = self

        // Add subviews
        view.addSubview(textView)

        // Layout constraints
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        textView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.5).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 80).isActive = true 
        
    }
    
    @objc func chooseImage() {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           present(imagePicker, animated: true, completion: nil)
        
        if isHaptic2Enabled {
                feedbackGenerator.selectionChanged()
        }
        
       }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let selectedImage = info[.originalImage] as? UIImage {
               imageView.image = selectedImage
               
               // Save the selected image as PNG data to UserDefaults
               if let imageData = selectedImage.pngData() {
                   UserDefaults.standard.set(imageData, forKey: "selectedImageData")
               }
           }
           picker.dismiss(animated: true, completion: nil)
       }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
    @objc func handleSwipeTop(gesture: UISwipeGestureRecognizer) {
            if isGestureEnabled {
               if gesture.direction == .up {
                   showColourPicker((Any).self)
               }
            }
        }
        
        @objc func handleSwipeDown(gesture: UISwipeGestureRecognizer) {
            if isGestureEnabled {
                if gesture.direction == .down {
                    showSettings()
                }
            }
        }
    
    @objc func handleSwipeRight(gesture: UISwipeGestureRecognizer) {
        if isGestureEnabled {
            if gesture.direction == .right {
                chooseImage()
            }
        }
     }
    
    @objc func handleSwipeLeft(gesture: UISwipeGestureRecognizer) {
        if isGestureEnabled {
            if gesture.direction == .left {
                showGallery()
            }
        }
     }
    
    
        @objc func handleTripleTap() {
                showSettings()
            }
    
    
    @objc func showGallery() {
            // Pass your image data to the GalleryView
            let galleryView = GalleryView(images: [
                ImageInfo(name: "Luna Shirakawa", author: "@kimizero_anime", imageName: "luna"),
                ImageInfo(name: "Mai Sakurajima", author: "@aobuta_anime", imageName: "mai"),
                ImageInfo(name: "Mai Sakurajima bunny ears", author: "@aobuta_anime", imageName: "mai-bunny-half"),
                ImageInfo(name: "Mai Sakurajima bunny", author: "@aobuta_anime", imageName: "mai-bunny"),
                ImageInfo(name: "Sakuta Azusagawa", author: "@aobuta_anime", imageName: "sakuta"),
                ImageInfo(name: "Nagisa Shiota", author: "@ansatsu_anime", imageName: "nagisa"),
                ImageInfo(name: "Kazuto Kirigaya", author: "@sao_anime", imageName: "kirito"),
                ImageInfo(name: "Asuna Yuuki", author: "@sao_anime", imageName: "asuna"),
                ImageInfo(name: "Aqua", author: "@konosubaanime", imageName: "aqua"),
            ])

            // Wrap the SwiftUI view in a UIHostingController
            let hostingController = UIHostingController(rootView: galleryView)

            // Present the hostingController
            present(hostingController, animated: true, completion: nil)
        
        if isHaptic2Enabled {
                feedbackGenerator.selectionChanged()
        }
    }
    
        
    @objc func showSettings() {
        let settingsView = SettingsView(
            isHaptic2Enabled: $isHaptic2Enabled,
            isGestureEnabled: $isGestureEnabled,
            isButtonEnabled: $isButtonEnabled
        )

        let settingsViewController = UIHostingController(rootView: settingsView)
        present(settingsViewController, animated: true, completion: nil)
        
        if isHaptic2Enabled {
                feedbackGenerator.selectionChanged()
        }
    }
    

@IBAction func showColourPicker(_ sender: Any) {
          let picker = UIColorPickerViewController()
          picker.delegate = self
          self.present(picker, animated: true, completion: nil)
    
    if isHaptic2Enabled {
            feedbackGenerator.selectionChanged()
    }
    
  }

    
}


  extension ViewController: UIColorPickerViewControllerDelegate {
      func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
          self.dismiss(animated: true, completion: nil)
      }
      
      func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
          let selectedColor = viewController.selectedColor
          
          // Save the selected color to UserDefaults
          if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: selectedColor, requiringSecureCoding: false) {
              UserDefaults.standard.set(colorData, forKey: "selectedColor")
          }
          
          // Update the background color of the main view
          self.view.backgroundColor = selectedColor
      }
}


extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Save the entered text to UserDefaults
        UserDefaults.standard.set(textView.text, forKey: "enteredText")
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder() // Dismiss the keyboard on return key
            return false
        }
        return true
    }
}

