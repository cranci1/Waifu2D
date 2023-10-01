import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @AppStorage("isHapticEnabled") private var isHapticEnabled = false
    @AppStorage("isHaptic2Enabled") private var isHaptic2Enabled = false
    @AppStorage("isAnimationEnabled") private var isAnimationEnabled = false
    @AppStorage("isButtonEnabled") private var isButtonEnabled = true
    @AppStorage("isGestureEnabled") private var isGestureEnabled = true

    
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
                   "That’s probably sugar inside. It’s white anyway.",
                   "It's okay not to be okay as long as you are willing to be honest about it.",
                   "People don't change that easily, but that doesn't mean change is impossible.",
                   "Reality is just a series of events and players deciding how they play their parts.",
                   "To know yourself is to know that you can't know yourself by yourself.",
                   "You only get one life. That's why, when you make a mistake, you should correct it.",
                   "People who have friends, people who aren't alone, are strong.",
                   "Even if we know each other’s feelings, it’s difficult to accept it. But it’s just as tough for the person telling us their feelings.",
                   "The harder you work for something, the greater you'll feel when you achieve it.",
                   "There are times when the world around you grows dark, and it's impossible to see any light. But it's during these times that you mustn't give in to despair. Fight through it, and you'll emerge stronger.",
                   "Sometimes it's the simple things that make life the most complicated.",
                   "As long as you're alive, that means you can keep fighting. There's always a possibility that everything will get better.",
                   "You shouldn't run away. You should confront it and grasp the situation. Then, you'll see hope.",
                   "The present is something you're supposed to protect and cherish. If you keep mulling over what's already happened, you'll lose sight of what's in front of you.",
                   "Sometimes, the things you're afraid of, the things you want to avoid, are the very things that make you stronger when you face them.",
                   "The moment you notice you've done something nice for someone, you lose the right to be arrogant about it.",
                   "People shouldn't be mean. We should live so that no one will want to be mean to us.",
                   "Just because you know someone well doesn't mean you know everything about them.",
                   "Love is not about how many days, months, or years you have been together. Love is about how much you love each other every single day.",
                   "It's not about being together physically; it's about feeling you here with me even when we're apart.",
                   "The best relationships usually begin unexpectedly.",
                   "Love is something that exists between a man and a woman, no matter how far they are from each other.",
                   "Sometimes, just spending time with the person you love can be the most romantic thing in the world."
               ]
    
    // An array of possible variants
        let variants = ["mai", "kaede", "koga", "futaba", "nodoka", "shoko"]

        var currentVariantIndex = 0
        
        // Create a UISelectionFeedbackGenerator for haptic feedback
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
               
               
               
        // Add a UISwipeGestureRecognizer for right swipes
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
            swipeRight.direction = .right
            view.addGestureRecognizer(swipeRight)
            
               
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
            swipeLeft.direction = .left
            view.addGestureRecognizer(swipeLeft)
               
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
            
            captionLabel.textColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                return traitCollection.userInterfaceStyle == .light ? .black : .white
            }
            
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
               
               if isButtonEnabled {
                       // Add the switchButton
                       let switchButton = UIButton(type: .system)
                       let cycleIconConfig = UIImage.SymbolConfiguration(pointSize: 25)
                       let cycleIcon = UIImage(systemName: "arrow.right", withConfiguration: cycleIconConfig)
                       switchButton.setImage(cycleIcon, for: .normal)
                       switchButton.tintColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                           return traitCollection.userInterfaceStyle == .light ? .black : .white
                       }
                       switchButton.addTarget(self, action: #selector(switchVariant), for: .touchUpInside)
                       switchButton.translatesAutoresizingMaskIntoConstraints = false
                       view.addSubview(switchButton)

                       NSLayoutConstraint.activate([
                           switchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                           switchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
                           switchButton.widthAnchor.constraint(equalToConstant: 45),
                           switchButton.heightAnchor.constraint(equalToConstant: 40)
                       ])

                       // Add the showColorPickerButton
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

                       // Adjust constraints for top-right positioning
                       showColorPickerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 56).isActive = true
                       showColorPickerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

                       // Add the arrowButton
                       let arrowButton = UIButton(type: .system)
                       let arrowIconConfig = UIImage.SymbolConfiguration(pointSize: 25)
                       let arrowIcon = UIImage(systemName: "arrow.2.circlepath", withConfiguration: arrowIconConfig)
                       arrowButton.setImage(arrowIcon, for: .normal)
                       arrowButton.tintColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                           return traitCollection.userInterfaceStyle == .light ? .black : .white
                       }
                       arrowButton.addTarget(self, action: #selector(changeTextAndImage), for: .touchUpInside)
                       arrowButton.translatesAutoresizingMaskIntoConstraints = false
                       view.addSubview(arrowButton)

                       // Create constraints to position the button at the bottom left
                       arrowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
                       arrowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true

                       // Add the showSettingsButton
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
                   }
               
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


    
    @objc func handleSwipeRight(gesture: UISwipeGestureRecognizer) {
    if isGestureEnabled {
        if gesture.direction == .right {
            changeTextAndImage()
        }
    }
 }
    
    @objc func handleSwipeLeft(gesture: UISwipeGestureRecognizer) {
    if isGestureEnabled {
        if gesture.direction == .left {
            switchVariant()
        }
    }
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

    @objc func handleTripleTap() {
            showSettings()
        }
    
    @objc func showSettings() {
        let settingsView = SettingsView(
            
            isHapticEnabled: $isHapticEnabled,
            isHaptic2Enabled: $isHaptic2Enabled,
            isAnimationEnabled: $isAnimationEnabled,
            isGestureEnabled: $isGestureEnabled,
            isButtonEnabled: $isButtonEnabled
            
        )
            let settingsViewController = UIHostingController(rootView: settingsView)
            present(settingsViewController, animated: true, completion: nil)
        }


    @objc func switchVariant() {
           currentVariantIndex = (currentVariantIndex + 1) % variants.count
           
           if isAnimationEnabled {
               let randomAnimationOptions: [UIView.AnimationOptions] = [
                   .transitionFlipFromLeft, .transitionFlipFromRight,
                   .transitionFlipFromTop, .transitionFlipFromBottom,
                   .transitionCrossDissolve, .transitionCurlUp, .transitionCurlDown,
               ]
               
               let randomIndex = Int(arc4random_uniform(UInt32(randomAnimationOptions.count)))
               let randomAnimation = randomAnimationOptions[randomIndex]
               
               UIView.transition(with: view, duration: 0.5, options: randomAnimation, animations: {
                   self.updateImageView()
                   
                   let captionLabel = self.view.subviews.compactMap { $0 as? UILabel }.first
                   captionLabel?.text = self.randomCaption()
               }, completion: nil)
               
               if isHapticEnabled {
                   feedbackGenerator.selectionChanged()
               }
           } else {
               // Perform non-animated logic when animation is disabled
               updateImageView()
               
               let captionLabel = view.subviews.compactMap { $0 as? UILabel }.first
               captionLabel?.text = randomCaption()
               
               if isHapticEnabled {
                   feedbackGenerator.selectionChanged()
               }
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
        imageNames = ["mai", "mai2", "mai3"]
        
    case "kaede":
        imageNames = ["kaede", "kaede2"]
    
    case "koga":
        imageNames = ["koga", "koga2"]
        
    case "futaba":
        imageNames = ["futaba", "futaba2"]
        
    case "nodoka":
        imageNames = ["nodoka", "nodoka2"]
        
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
}
