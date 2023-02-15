
import UIKit
import FirebaseAuth
import FirebaseDatabase
import DropDown


class SignUpViewController: UIViewController {
    
    private let database = Database.database(url: "https://sky-go-hybrid-calendar-app-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    
    let skyLogo = UIImageView()
    let usernameLabel = UILabel()
    let usernameTextInput = UITextField()
    let passwordLabel = UILabel()
    let passwordTextInput = UITextField()
    let fullNameLabel = UILabel()
    let fullNameTextInput = UITextField()
    let jobTitleLabel = UILabel()
    let jobTitleTextInput = UITextField()
    let departmentButton = UIButton()
    let departmentDropdown = DropDown()
    let locationButton = UIButton()
    let locationDropdown = DropDown()
    let signUpButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign Up"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupLogo()
        setupScrollView()
        setupViews()

    }
    
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 20.0
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillEqually
        
        [self.usernameLabel,
         self.usernameTextInput,
         self.passwordLabel,
         self.passwordTextInput,
         self.fullNameLabel,
         self.fullNameTextInput,
         self.jobTitleLabel,
         self.jobTitleTextInput,
         self.departmentDropdown,
         self.departmentButton,
         self.locationButton,
         
         self.signUpButton].forEach {contentStackView.addArrangedSubview($0)}
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: skyLogo.bottomAnchor, constant: 25),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentStackView.widthAnchor.constraint(equalToConstant: 300),
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    func setupViews() {
        setupLabels()
        setupTextFields()
        setupButtons()
        setupDropdowns()
    }
    
    func setupDropdowns() {
        departmentDropdown.anchorView = departmentButton
        departmentDropdown.dataSource = ["Sky Go", "Now", "Core", "OVP"]
        departmentDropdown.direction = .any
        
        locationDropdown.anchorView = departmentButton
        locationDropdown.dataSource = ["Osterley", "Leeds", "Brentwood"]
        locationDropdown.direction = .any
        
        departmentDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.departmentButton.configuration?.title = "\(item)"
        }
        
        locationDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.locationButton.configuration?.title = "\(item)"
        }
    }
    
    func setupButtons() {
        
        signUpButton.configuration = .filled()
        signUpButton.configuration?.baseBackgroundColor = .systemOrange
        signUpButton.configuration?.title = "Sign Up"
        signUpButton.configuration?.baseForegroundColor = .black
        
        departmentButton.configuration = .borderedProminent()
        departmentButton.configuration?.baseBackgroundColor = .systemBlue
        departmentButton.configuration?.title = "Choose Department"
        departmentButton.configuration?.baseForegroundColor = .black
        
        locationButton.configuration = .borderedProminent()
        locationButton.configuration?.baseBackgroundColor = .systemBlue
        locationButton.configuration?.title = "Choose Location"
        locationButton.configuration?.baseForegroundColor = .black
        
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        departmentButton.addTarget(self, action: #selector(handleDepartmentDropdown), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(handleLocationDropdown), for: .touchUpInside)
        
    }
    
    @objc func handleDepartmentDropdown () {
        departmentDropdown.show()
    }
    
    @objc func handleLocationDropdown () {
        locationDropdown.show()
    }

    
    @objc func handleSignUp() {
        let email:String = usernameTextInput.text!
        let password:String = passwordTextInput.text!
        let profile: [String:Any] = [
            "name": fullNameTextInput.text! as NSObject,
            "jobTitle": jobTitleTextInput.text!,
            "department": departmentButton.configuration?.title as Any,
            "location": locationButton.configuration?.title as Any,
        ]
        
        Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
            if (authResult != nil) {
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                  guard let _ = self else { return }
                    self?.database.child("users").child(Auth.auth().currentUser!.uid).setValue(profile)
                }
            } else {
                print("Error Signing User Up")
            }
        }
        
    }
    
    func setupLogo() {
        skyLogo.image = UIImage(named: "skyLogo")
        view.addSubview(skyLogo)
        
        skyLogo.contentMode = .scaleAspectFit
        
        skyLogo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            skyLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skyLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            skyLogo.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func setupLabels() {
        
        usernameLabel.text = "Username:"
        usernameLabel.textAlignment = .left
        
        passwordLabel.text = "Password:"
        passwordLabel.textAlignment = .left
        
        fullNameLabel.text = "Full Name:"
        fullNameLabel.textAlignment = .left
        
        jobTitleLabel.text = "Job Title:"
        jobTitleLabel.textAlignment = .left
        
        
    }
    
    func setupTextFields() {
        
        usernameTextInput.borderStyle = .roundedRect
        usernameTextInput.textColor = .black
        usernameTextInput.autocorrectionType = UITextAutocorrectionType.no
        usernameTextInput.autocapitalizationType = UITextAutocapitalizationType.none
        
        passwordTextInput.borderStyle = .roundedRect
        passwordTextInput.textColor = .black
        passwordTextInput.autocorrectionType = UITextAutocorrectionType.no
        passwordTextInput.autocapitalizationType = UITextAutocapitalizationType.none
        
        fullNameTextInput.borderStyle = .roundedRect
        fullNameTextInput.textColor = .black
        fullNameTextInput.autocorrectionType = UITextAutocorrectionType.no
        fullNameTextInput.autocapitalizationType = UITextAutocapitalizationType.words
        
        jobTitleTextInput.borderStyle = .roundedRect
        jobTitleTextInput.textColor = .black
        jobTitleTextInput.autocapitalizationType = UITextAutocapitalizationType.words

    }

}

