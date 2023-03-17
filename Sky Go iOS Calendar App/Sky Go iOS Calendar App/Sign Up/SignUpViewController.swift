
import UIKit
import FirebaseAuth
import FirebaseDatabase
import DropDown


class SignUpViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate, SignUpPresenterDelegate {
    
    var presenter: SignUpPresenter
    
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    
    let skyLogo = UIImageView()
    
    let addProfileImageButton = UIButton()
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
    
    init(database:DatabaseReferenceProtocol) {
        presenter = SignUpPresenter(database: database)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        [self.addProfileImageButton,
         self.usernameLabel,
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
        departmentDropdown.dataSource = presenter.populateDepartmentDropdown()
        departmentDropdown.direction = .any
        
        locationDropdown.anchorView = departmentButton
        locationDropdown.dataSource = presenter.populateLocationDropdown()
        locationDropdown.direction = .any
        
        departmentDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.departmentButton.configuration?.title = "\(item)"
        }
        
        locationDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.locationButton.configuration?.title = "\(item)"
        }
    }
    
    func setupButtons() {
        let addProfileImage  = UIImage(named: "addProfileIcon")
        
        addProfileImageButton.setImage(addProfileImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        addProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
//        addProfileImageButton.contentMode = .scaleAspectFit
//        NSLayoutConstraint.activate([
//            addProfileImageButton.heightAnchor.constraint(equalToConstant: 50),
//        ])
//
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
        
        addProfileImageButton.addTarget(self, action: #selector(showProfilePicker), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        departmentButton.addTarget(self, action: #selector(handleDepartmentDropdown), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(handleLocationDropdown), for: .touchUpInside)
        
    }
    
    @objc func showProfilePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if let sheet = picker.presentationController as? UISheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
        }
        
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        addProfileImageButton.setImage(image, for: .normal)
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
//        let profile: [String:Any] = [
//            "name": fullNameTextInput.text! as NSObject,
//            "jobTitle": jobTitleTextInput.text!,
//            "department": departmentButton.configuration?.title as Any,
//            "location": locationButton.configuration?.title as Any,
//        ]
        let profile: User = User(name: fullNameTextInput.text!,
                                 jobTitle: jobTitleTextInput.text!,
                                 department: departmentButton.configuration?.title ?? "Not Selected",
                                 location: locationButton.configuration?.title ?? "Not Selected")
        presenter.signUpUser(email: email, password: password, user: profile)
        
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

