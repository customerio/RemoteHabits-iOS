//
//  DashboardViewController.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 29/11/21.
//

import UIKit

class RHDashboardViewController: RHBaseViewController {

    // MARK: - --OUTLETS--
    @IBOutlet weak var dashboardTableView: UITableView!
    
    // MARK: - --VARIABLES--
    let dashboardHeaders = RemoteHabitsData().getHabitHeaders()
    var isSourceLogin : Bool = false
    let habitsDataManager = HabitDataManager()
    var profileViewModel = DI.shared.profileViewModel
    var trackerViewModel = DI.shared.trackerViewModel
    
    // MARK: - --LIFECYCLE METHODS--
    override func viewDidLoad() {
        super.viewDidLoad()

//        let habitsData = HabitDataManager().getHabit(forIds: dashboardHeaders.first?.ids)
        configureNavigationBar(title: RHConstants.kEmptyValue, hideBack: true, showLogo : true)
        addDefaultBackground()
        setupDashboardTableView()
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        
    }
    
    // MARK: - --FUNCTIONS--
    func setupDashboardTableView() {
        
        // HabitTableViewCell move to constant file
        dashboardTableView.register(UINib(nibName: RHConstants.kHabitTableViewCell, bundle: nil), forCellReuseIdentifier: RHConstants.kHabitTableViewCell)
        dashboardTableView.rowHeight = UITableView.automaticDimension
        dashboardTableView.estimatedRowHeight = 80
        
    }
    
    func route(withData : Habits) {
        if let viewController  = UIStoryboard(name: RHConstants.kStoryboardMain, bundle: nil).instantiateViewController(withIdentifier: RHConstants.kHabitDetailViewController) as? RHHabitDetailViewController {
            
            viewController.habitDetailData = withData
            let navigation = UINavigationController.init(rootViewController: viewController)
            self.present(navigation, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - --NAVIGATION--

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - --UITABLEVIEWDELEGATE--
extension RHDashboardViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 97.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 97))
        headerView.backgroundColor = self.view.backgroundColor
        let headerData = dashboardHeaders[section]
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 5, width: headerView.frame.width-20, height: headerView.frame.height-10)
        if section != 0 {
            label.frame = CGRect.init(x: 16, y: 60, width: headerView.frame.width-20, height: 26)
        }
        
        label.text = headerData.headerTitle ?? RHConstants.kEmptyValue
        label.font = UIFont(name: headerData.titleFontName ?? RHConstants.kEmptyValue, size: CGFloat(headerData.titleFontSize ?? 17))
        label.textColor = .black
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section != 0 { return }
        
        guard let id = dashboardHeaders[indexPath.section].ids?[indexPath.row], let habitData = habitsDataManager.getHabit(forIds: [id])?.first else {
            return
        }
        
        let selectedHabit = SelectedHabitData(title: habitData.title, frequency: Int(habitData.frequency), startTime: habitData.startTime?.formatDateToString(inFormat: .time12Hour), endTime: habitData.endTime?.formatDateToString(inFormat: .time12Hour), id: Int(habitData.id), isEnabled: habitData.isEnabled)
        trackerViewModel.trackHabitActivity(withName: RHConstants.kHabitClicked, forHabit: selectedHabit)
        habitsDataManager.updateHabit(withData: selectedHabit)
        self.route(withData : habitData)
    }
}

// MARK: - --UITABLEVIEWDATASOURCE--
extension RHDashboardViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dashboardHeaders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardHeaders[section].ids?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RHConstants.kHabitTableViewCell, for: indexPath) as? HabitTableViewCell, let id = dashboardHeaders[indexPath.section].ids?[indexPath.row], let habitData = habitsDataManager.getHabit(forIds: [id])?.first else {
            return UITableViewCell()
        }
        
//        let id = dashboardHeaders[indexPath.section].ids?[indexPath.row] ?? 0
//        let habitData = habitsDataManager.getHabit(forIds: [id])
        cell.selectionStyle = .none
        cell.actionDelegate = self
        cell.habitData = habitData
        cell.fillData()
        
        return cell
    }
}


// MARK: - Protocol - RHDashboardActionHandler
extension RHDashboardViewController : RHDashboardActionHandler {
 
    func toggleHabit(toValue isEnabled: Bool, habitData : SelectedHabitData) {
        trackerViewModel.trackHabitActivity(withName: isEnabled ? RHConstants.kHabitEnabled : RHConstants.kHabitDisabled, forHabit: habitData)
        habitsDataManager.updateHabit(withData: habitData)
    }
    
    func logoutUser() {
        self.profileViewModel.logoutUser()
//        self.habitsDataManager.deleteHabits()
//        let data = RemoteHabitsData().getHabitsData()
//        self.habitsDataManager.createHabit(forData: data)
        
        if isSourceLogin {
            self.navigationController?.popToRootViewController(animated: true)
        }else  {
            let main = UIStoryboard(name: RHConstants.kStoryboardMain, bundle: nil)
            let vc = main.instantiateViewController(withIdentifier: RHConstants.kLoginViewController) as! RHLoginViewController
            navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    func loginUser() {
//        self.habitsDataManager.deleteHabits()
//        let data = RemoteHabitsData().getHabitsData()
//        self.habitsDataManager.createHabit(forData: data)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func switchWorkspace() {
        if let viewController  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: RHConstants.kSwitchWorkspaceViewController) as? RHSwitchWorkspaceViewController {
            
            let navigation = UINavigationController.init(rootViewController: viewController)
            self.present(navigation, animated: true, completion: nil)
        }
    }
}
