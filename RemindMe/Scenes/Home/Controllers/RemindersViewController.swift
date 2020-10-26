//
//  TaskViewController.swift
//  RemindMe
//
//  Created by Kevin Vu on 9/25/20.
//  Copyright © 2020 Kevin Vu. All rights reserved.
//

import UIKit
import Firebase

class RemindersViewController: UIViewController {
    
    // MARK: Constants
    let usersConstant = "users"
    
    // MARK: Properties
    
    var contentView: RemindersView!
    
    var user: User = User(uid: "fakeID", email: "fakeEmail@example.com")
    lazy var usersRef = Database.database().reference(withPath: usersConstant)
    lazy var currentUserRef = usersRef.child(user.uid)
    var authHandle: AuthStateDidChangeListenerHandle?
    
    var reminderItems = [ReminderItem]()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // this adds auth listener
        authenticateUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let authHandle = authHandle else { return }
        Auth.auth().removeStateDidChangeListener(authHandle)
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setTableViewDelegate()
//        configureNavBar()
    }
    
    // MARK: Setup
    private func setupView() {
        let view = RemindersView()
        contentView = view
    }
    
    private func setTableViewDelegate() {
        contentView.remindersTableView.delegate = self
        contentView.remindersTableView.dataSource = self
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddReminderBarButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(testPresentAlertVC))
    }
    
    private func setup() {
        setupView()
        setTableViewDelegate()
        configureNavBar()
    }
    
    
    // MARK: Auth methods
    private func signInOnLoad() {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else { return }
            
            self.user = User(authData: user)
            self.addRemindersRefObserver()
        }
    }
    
    private func addAuthListener(completion: @escaping () -> ()) {
        authHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else { return }
            
            self.user = User(authData: user)
            // completion is used to tell the caller that the user is authenticated
            // and signed in - thus we can now observe the corresponding user's
            // reminder items reference
            completion()
        }
    }
    
    private func authenticateUser() {
        // no user, we should login
        if Auth.auth().currentUser == nil {
            signInOnLoad()
        }
        addAuthListener { [weak self] in
            guard let self = self else { return }
            // authentication has completed, add the reference observer to get data
            self.addRemindersRefObserver()
            print("YAY")
        }
    }
    
    // MARK: Firebase - Add item
    
    @objc func didTapAddReminderBarButton() {
        let ac = UIAlertController(title: "Reminder",
                                   message: "Add a reminder",
                                   preferredStyle: .alert)
        
        // 0 - name of reminder
        // 1 - user (should eventually be email of user)
        // 2 - reminder type (should be a UIPickerView eventually)
        // 3 - date added (current date)
        // 4 - current interval start date (just use current date)
        ac.addTextField()
        ac.textFields?.first?.placeholder = "Name of reminder"
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] (action) in
            
            guard
                let self = self,
                let nameTextField = ac.textFields?.first,
                // grab start date here
                let nameText = nameTextField.text else { return }
            
            /*
             TODO: Either do reminder date calculation here or delegate to a helper class (e.g.:
             
             let reminderCalculator = ReminderDateCalculator()
             reminderCalculator.findUpcomingDate(fromDate: Date(), withInterval: DateComponents)
             )
             
             Also, check if there is already a reminder with the same name.
             If so, find the # of duplicate results in the reminderItems array
             and append something like (2) or (3) based on the # of dupes
             
             probably something like
             
             for reminder in reminderItems {
                if reminder.nameOfReminder == nameText {
                    numOfDupes += 1
                } else {
                    continue
                }
             }
             
             nameOfReminder: "\(nameText) \(numOfDupes + 1)"
             
             [e.g. if there was 1 dupe, the resulting name would be something like
             "bananas (2)"]
            */
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            guard let customDateTest = formatter.date(from: "2020/11/04") else { return }
            
            let reminder = ReminderItem(nameOfReminder: nameText, addedByUser: "kevinvu59@gmail.com", reminderType: .routineTask, currentIntervalStartDate: Date(), upcomingReminderTriggerDate: customDateTest)
            
            let reminderItemRef = self.currentUserRef.child(nameText.lowercased())
            
            self.reminderItems.append(reminder)
            reminderItemRef.setValue(reminder.toDict())
            
            self.contentView.remindersTableView.reloadData()
        }
        
        ac.addAction(cancelAction)
        ac.addAction(saveAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    // MARK: Nav bar methods
    @objc func testPresentAlertVC() {
        let addReminderAlertVC = AddReminderAlertController()
        let navVC = UINavigationController(rootViewController: addReminderAlertVC)
        
        navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    // MARK: Reminders ref observer
    
    private func addRemindersRefObserver() {
        currentUserRef.observe(.value) { (snapshot) in
            var newReminderItems: [ReminderItem] = []
            
            for child in snapshot.children {
                guard
                    let snapshot = child as? DataSnapshot,
                    let reminderItem = ReminderItem(snapshot: snapshot)
                else { return }
                
                newReminderItems.append(reminderItem)
            }
            
            self.reminderItems = newReminderItems
            self.contentView.remindersTableView.reloadData()
        }
    }
    
}

// MARK: Table view methods
extension RemindersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RemindersTableViewCell.cellID, for: indexPath) as! RemindersTableViewCell
        
        let reminderItem = reminderItems[indexPath.row]
        
        let model = RemindersTableViewCell.RemindersCellModel(nameOfReminder: reminderItem.nameOfReminder, timeRemaining: 5, reminderType: reminderItem.reminderType)
        
        cell.configureCell(withModel: model)
        /*
         TODO: Add a date variable to ReminderItem and delegate checking
         the time remaining to a separate model/worker
         
         This needs to check the stored dateinterval and/or the remaining time
         so that the remaining time can be updated and presented as a string
         */
        
        return cell
    }
    
}


// MARK: View delegate methods
extension RemindersViewController: RemindersViewDelegate {
    
    func didTapAddReminderButton() {
        print("Tapped add")
    }
    
    func didTapRemoveReminderButton() {
        print("Tapped remove")
    }
    
    
}

