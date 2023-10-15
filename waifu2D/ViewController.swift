import UIKit
import SwiftUI
import LocalAuthentication

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var overlayView: UIView?
    var authenticationLabel: UILabel?
    
    
    @AppStorage("isHaptic2Enabled") private var isHaptic2Enabled = false
    @AppStorage("isButtonEnabled") private var isButtonEnabled = true
    @AppStorage("isGestureEnabled") private var isGestureEnabled = true
    @AppStorage("isPasscodeEnabled") private var isPasscodeEnabled = false

    
    var isBiometricAuthenticated = false
    
    let textView = UITextView()
    let imageView = UIImageView()
    
    let feedbackGenerator = UISelectionFeedbackGenerator()
    
    
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
            let showSettingsConfig = UIImage.SymbolConfiguration(pointSize: 25)
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
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        

        view.addSubview(imageView)
        

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.6).isActive = true
        
        

    if let savedColorData = UserDefaults.standard.data(forKey: "selectedColor"),
        let savedColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedColorData) as? UIColor {
        self.view.backgroundColor = savedColor
    }
        
        textView.backgroundColor = UIColor(white: 1, alpha: 0)
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .center
        textView.delegate = self

        view.addSubview(textView)

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        textView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.5).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 80).isActive = true
     
        if isPasscodeEnabled {
        authenticate()
        }
        
        if !isPasscodeEnabled {
            isBiometricAuthenticated = true
        }
        
    }
    
    func authenticate() {
            let context = LAContext()
            var error: NSError?

            // Check whether it's possible to use biometric authentication
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                // Biometric authentication is available, use it
                showOverlay()

                // Handle Face ID
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "This is a security check reason.") { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            // Update UI or perform any actions upon successful authentication
                            print("Biometric authentication successful")
                            self.isBiometricAuthenticated = true
                            self.hideOverlay()
                        } else {
                            // Handle other authentication failures
                            print("Biometric authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                            self.showAuthenticationError(withPasscodeFallback: true)
                        }
                    }
                }
            } else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                // Biometric authentication is not available, prompt for passcode
                showOverlay()

                // Handle Touch ID
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "This is a security check reason.") { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            // Update UI or perform any actions upon successful authentication
                            print("Biometric authentication (Touch ID) successful")
                            self.isBiometricAuthenticated = true
                            self.hideOverlay()
                        } else {
                            // Handle passcode authentication failure
                            print("Passcode authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                            self.showAuthenticationError(withPasscodeFallback: true)
                        }
                    }
                }
            } else {
                // Handle the case where biometrics are not available
                print("Phone does not have biometrics")
            }
        }

    func showOverlay() {
            overlayView = UIView(frame: view.bounds)
            overlayView?.backgroundColor = UIColor(white: 0, alpha: 1.0)
            view.addSubview(overlayView!)

            
            let lockIcon = UIImageView(image: UIImage(systemName: "lock.fill"))
            lockIcon.tintColor = .white
            lockIcon.frame = CGRect(x: (overlayView!.bounds.width - 30) / 2, y: 70, width: 30, height: 30)
            overlayView?.addSubview(lockIcon)

            
            authenticationLabel = UILabel(frame: CGRect(x: 0, y: 85, width: overlayView!.bounds.width, height: 80))
            authenticationLabel?.text = "Please Authenticate"
            authenticationLabel?.textColor = .white
            authenticationLabel?.textAlignment = .center
            authenticationLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            overlayView?.addSubview(authenticationLabel!)
        }

        func hideOverlay() {
            overlayView?.removeFromSuperview()
        }

    func showAuthenticationError(withPasscodeFallback: Bool) {
            let alertController = UIAlertController(title: "Authentication Failed", message: "Please re-authenticate.", preferredStyle: .alert)
            
            if withPasscodeFallback {
                let passcodeAction = UIAlertAction(title: "Use Passcode", style: .default) { _ in
                    self.showPasscodePrompt()
                }
                alertController.addAction(passcodeAction)
            }
            
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        }

        func showPasscodePrompt() {
            let context = LAContext()
            var _: NSError?

            // Display the passcode entry prompt
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Please enter your passcode.") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Passcode authentication successful
                        print("Passcode authentication successful")
                        self.isBiometricAuthenticated = true
                        self.hideOverlay()
                    } else {
                        // Passcode authentication failed
                        print("Passcode authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                        // Handle failure if needed
                    }
                }
            }
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
            if isGestureEnabled && isBiometricAuthenticated {
               if gesture.direction == .up {
                   showColourPicker((Any).self)
               }
            }
        }
        
        @objc func handleSwipeDown(gesture: UISwipeGestureRecognizer) {
            if isGestureEnabled && isBiometricAuthenticated {
                if gesture.direction == .down {
                    showSettings()
                }
            }
        }
    
    @objc func handleSwipeRight(gesture: UISwipeGestureRecognizer) {
        if isGestureEnabled && isBiometricAuthenticated {
            if gesture.direction == .right {
                chooseImage()
            }
        }
     }
    
    @objc func handleSwipeLeft(gesture: UISwipeGestureRecognizer) {
        if isGestureEnabled && isBiometricAuthenticated {
            if gesture.direction == .left {
                showGallery()
            }
        }
     }
    
    
        @objc func handleTripleTap() {
            if isBiometricAuthenticated {
                showSettings()
            }
        }
    
    
    @objc func showGallery() {
            let galleryView = GalleryView(images: [
                
                ImageInfo(name: "Luna Shirakawa", author: "@kimizero_anime", imageName: "luna"),
                ImageInfo(name: "Mai Sakurajima", author: "@aobuta_anime", imageName: "mai"),
                ImageInfo(name: "Mai Sakurajima bunny ears", author: "@aobuta_anime", imageName: "mai-bunny-half"),
                ImageInfo(name: "Mai Sakurajima bunny", author: "@aobuta_anime", imageName: "mai-bunny"),
                ImageInfo(name: "Asuna Yuuki", author: "@sao_anime", imageName: "asuna"),
                ImageInfo(name: "Aqua", author: "@konosubaanime", imageName: "aqua")
                
            ])

            
            let hostingController = UIHostingController(rootView: galleryView)

            present(hostingController, animated: true, completion: nil)
        
        if isHaptic2Enabled {
                feedbackGenerator.selectionChanged()
        }
    }
    
        
    @objc func showSettings() {
        let settingsView = SettingsView(
            isHaptic2Enabled: $isHaptic2Enabled,
            isGestureEnabled: $isGestureEnabled,
            isButtonEnabled: $isButtonEnabled,
            isPasscodeEnabled: $isPasscodeEnabled
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
          
          
          if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: selectedColor, requiringSecureCoding: false) {
              UserDefaults.standard.set(colorData, forKey: "selectedColor")
          }
          
        
          self.view.backgroundColor = selectedColor
      }
}


extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        UserDefaults.standard.set(textView.text, forKey: "enteredText")
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder() 
            return false
        }
        return true
    }
}
