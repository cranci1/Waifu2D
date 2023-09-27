import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @AppStorage("isHapticEnabled") private var isHapticEnabled = false
    @AppStorage("isHaptic2Enabled") private var isHaptic2Enabled = false

    
    // Arrays of text captions for each variant
               let RascalCaptions = [
                   "What I think, Sakuta-kun, is that life is here for us to become kinder. I live life every day hoping I was a slightly kinder person than I was the day before.",
                   "I don’t mind if I only had one person. Even if the whole world hated me, I could keep living if that person needed me.",
                   "No matter who you were before, how you look right now is who you are.",
                   "It’s foolish to fight the atmosphere when the people creating it don’t have a sense of it.",
                   "It’s not like I live for all of humanity to like me.",
                   "Once the class takes shape it doesn’t change easily.",
                   "Big Brother has given Kaede so much happiness. She loves him now, has always loved him, and will always love him.",
                   "Forget what you saw today. Also, don’t have anything to do with me under any circumstances. If you understand, then say yes.",
                   "I can’t allow her to sleep in the same house as you, so I’ll have to sleep there as well to keep an eye on her.",
                   "You’re having lewd thoughts, aren’t you?",
                   "Nothing less from you, Azusagawa. Such a rascal",
                   "I want everyone to like me. Or rather, I don’t want them to hate me.",
                   "You know Sakuta, its likely that I'm more in love with you than you think.",
                   "Mai: If you're lying to me, I'll make you eat Pocky through your nose.   Sakuta: One stick?    Mai: One box.",
                   "I live my life following these words: 'Thank you', 'You did your best', and 'I love you'.",
                   "I lied, I like you very much",
                   "I think you split my ass in two!” “What? That sounds ba— Wait a second, it already was!",
               ]

               
    
    // An array of possible variants
        let variants = ["mai", "kaede", "koga", "futaba", "nodoka", "shoko"]

        var currentVariantIndex = 0
        
        // Create a UISelectionFeedbackGenerator for haptic feedback
        let feedbackGenerator = UISelectionFeedbackGenerator()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Load the previously selected color (if any)
            if let savedColorData = UserDefaults.standard.data(forKey: "selectedColor"),
                       let savedColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedColorData) as? UIColor {
                        self.view.backgroundColor = savedColor
                    }
            

            // Create a UIImageView and set the image based on the current variant
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75),
                imageView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8),
                imageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.6)
            ])
            
            // Create a UILabel for the initial variant and caption
            let captionLabel = UILabel()
            captionLabel.text = randomCaption()
            captionLabel.textColor = .white
            captionLabel.textAlignment = .center
            captionLabel.numberOfLines = 0
            captionLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(captionLabel)
            
            NSLayoutConstraint.activate([
                captionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                captionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
                captionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                captionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
            
            // Create a button with the icon for switching variants
            let switchButton = UIButton(type: .system)
            let cycleIconConfig = UIImage.SymbolConfiguration(pointSize: 25)
            let cycleIcon = UIImage(systemName: "arrow.right", withConfiguration: cycleIconConfig)
            switchButton.setImage(cycleIcon, for: .normal)
            switchButton.tintColor = .white
            switchButton.addTarget(self, action: #selector(switchVariant), for: .touchUpInside)
            switchButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(switchButton)
            
            NSLayoutConstraint.activate([
                switchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                switchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
                switchButton.widthAnchor.constraint(equalToConstant: 45),
                switchButton.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            // Create a button with the right arrow icon for changing text and image
            let arrowButton = UIButton(type: .system)
            let arrowIconConfig = UIImage.SymbolConfiguration(pointSize: 25)
            let arrowIcon = UIImage(systemName: "arrow.2.circlepath", withConfiguration: arrowIconConfig)
            arrowButton.setImage(arrowIcon, for: .normal)
            arrowButton.tintColor = .white
            arrowButton.addTarget(self, action: #selector(changeTextAndImage), for: .touchUpInside)
            arrowButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(arrowButton)
            
            // Create constraints to position the button at the bottom left
            arrowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            arrowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
            
            
            // Create a button to present the settingsView
            let showSettingsButton = UIButton(type: .system)
            let showSettingsConfig = UIImage.SymbolConfiguration(pointSize: 20)
            let showSettingsIcon = UIImage(systemName: "gear", withConfiguration: showSettingsConfig)
            showSettingsButton.tintColor = .white
            showSettingsButton.setImage(showSettingsIcon, for: .normal)
            showSettingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
            showSettingsButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(showSettingsButton)

            showSettingsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
            showSettingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            
            // Set the initial image based on the current variant
            updateImageView()
        }
    
        
    // Function to generate a random caption based on the current variant
    func randomCaption() -> String {
        var captionsForVariant: [String]
        
        switch variants[currentVariantIndex] {
            
        case "mai":
            captionsForVariant = RascalCaptions
            
        case "kaede":
            captionsForVariant = RascalCaptions
            
        case "koga":
            captionsForVariant = RascalCaptions
            
        case "futaba":
            captionsForVariant = RascalCaptions
            
        case "nodoka":
            captionsForVariant = RascalCaptions
            
        case "shoko":
            captionsForVariant = RascalCaptions
            
            
        default:
            captionsForVariant = []
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(captionsForVariant.count)))
        return captionsForVariant[randomIndex]
    }


    

@objc func showSettings() {
    let settingsView = SettingsView(
        isHapticEnabled: $isHapticEnabled,
        isHaptic2Enabled: $isHaptic2Enabled
    )
        let settingsViewController = UIHostingController(rootView: settingsView)
        present(settingsViewController, animated: true, completion: nil)
    }


    @objc func switchVariant() {
                    currentVariantIndex = (currentVariantIndex + 1) % variants.count
                    updateImageView()
                    
                    let captionLabel = view.subviews.compactMap { $0 as? UILabel }.first
                    captionLabel?.text = randomCaption()
                    
        if isHapticEnabled {
                    feedbackGenerator.selectionChanged()
                }
            }
    
        
        @objc func changeTextAndImage() {
            let captionLabel = view.subviews.compactMap { $0 as? UILabel }.first
            captionLabel?.text = randomCaption()
            
            // 1 in 2 chance to change the image
            if Int.random(in: 1...2) == 1 {
                updateImageView()
            }
            
            if isHaptic2Enabled {
                        feedbackGenerator.selectionChanged()
                    }
        }


// Function to update the image view based on the current variant
func updateImageView() {
    let currentVariant = variants[currentVariantIndex]
    
    var imageNames: [String] = []
    
    switch currentVariant {
    case "mai":
        imageNames = ["mai", "mai2"]
        
    case "kaede":
        imageNames = ["kaede", "kaede2"]
    
    case "koga":
        imageNames = ["koga", "koga2"]
        
    case "futaba":
        imageNames = ["futaba"]
        
    case "nodoka":
        imageNames = ["nodoka"]
        
    case "shoko":
        imageNames = ["shoko", "shoko2"]
    
    default:
        imageNames = []
    }
    
    let randomIndex = Int(arc4random_uniform(UInt32(imageNames.count)))
    let imageName = imageNames[randomIndex]
    
    if let image = UIImage(named: imageName) {
        for subview in view.subviews {
            if let imageView = subview as? UIImageView {
                imageView.image = image
                break
            }
        }
    }
}

    @IBAction func showColourPicker(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
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
} // #4295BB
