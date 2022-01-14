import UIKit

class DashboardViewController: BaseViewController {
    static func newInstance() -> DashboardViewController {
        UIStoryboard.getViewController(identifier: Constants.kDashboardViewController)
    }

    // MARK: - --OUTLETS--

    @IBOutlet var dashboardTableView: UITableView!

    // MARK: - --VARIABLES--

    let remoteHabitsData = RemoteHabitsData()
    var dashboardHeaders: [HabitHeadersInfo] = .init()
    var isSourceLogin: Bool = false
    var profileViewModel = DI.shared.profileViewModel

    // MARK: - --LIFECYCLE METHODS--

    override func viewDidLoad() {
        super.viewDidLoad()

        dashboardHeaders = remoteHabitsData.getHabitHeaders()
        configureNavigationBar(title: Constants.kEmptyValue, hideBack: true, showLogo: true)
        addNotifierObserver()
        addDefaultBackground()
        setupDashboardTableView()
        // Do any additional setup after loading the view.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - --FUNCTIONS--

    func addNotifierObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHabitsData(notification:)),
                                               name: Notification.Name(Constants.kHabitsUpdatedIdentifier),
                                               object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleSwitchWorkspace(notification:)),
                                               name: Notification
                                                   .Name(Constants.kSwitchWorkspaceNotificationIdentifier),
                                               object: nil)
    }

    @objc func reloadHabitsData(notification: Notification) {
        dashboardTableView.reloadData()
    }

    func setupDashboardTableView() {
        dashboardTableView.register(UINib(nibName: Constants.kHabitTableViewCell, bundle: nil),
                                    forCellReuseIdentifier: Constants.kHabitTableViewCell)
        dashboardTableView.setAutomaticRowHeight(height: .defaultHeight)
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
    }

    @objc func handleSwitchWorkspace(notification: Notification) {
        guard let siteId = notification.userInfo?["site_id"] as? String,
              let apiKey = notification.userInfo?["api_key"] as? String
        else {
            route(to: Constants.kSwitchWorkspaceViewController)
            return
        }
        let workspaceData = WorkspaceData(apiKey: siteId, siteId: apiKey)
        route(to: Constants.kSwitchWorkspaceViewController, withData: workspaceData)
    }

    // MARK: - --NAVIGATION--

    func route(to controller: String, withData: Any? = nil) {
        switch controller {
        case Constants.kHabitDetailViewController:
            navigateToDashboardDetail(withData: withData as? Habits)
        case Constants.kSwitchWorkspaceViewController:
            navigateToWorkspace(withData: withData as? WorkspaceData)
        default:
            break
        }
    }

    func navigateToDashboardDetail(withData: Habits?) {
        if let viewController = UIStoryboard(name: Constants.kStoryboardMain, bundle: nil)
            .instantiateViewController(withIdentifier: Constants
                .kHabitDetailViewController) as? HabitDetailViewController, let habitData = withData {
            viewController.habitDetailData = habitData
            let navigation = UINavigationController(rootViewController: viewController)
            present(navigation, animated: true, completion: nil)
        }
    }

    func navigateToWorkspace(withData workspaceData: WorkspaceData?) {
        if let presented = self.presentedViewController {
            presented.dismiss(animated: false)
        }
        if let viewController = UIStoryboard(name: Constants.kStoryboardMain, bundle: nil)
            .instantiateViewController(withIdentifier: Constants
                .kSwitchWorkspaceViewController) as? SwitchWorkspaceViewController {
            viewController.workspaceData = workspaceData
            let navigation = UINavigationController(rootViewController: viewController)
            present(navigation, animated: true, completion: nil)
        }
    }
}

// MARK: - --UITABLEVIEWDELEGATE--

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        97.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 97))
        headerView.backgroundColor = view.backgroundColor
        let headerData = dashboardHeaders[section]
        let label = UILabel()
        label.frame = CGRect(x: 16, y: 5, width: headerView.frame.width - 20, height: headerView.frame.height - 10)
        if section != 0 {
            label.frame = CGRect(x: 16, y: 60, width: headerView.frame.width - 20, height: 26)
        }

        label.text = headerData.headerTitle ?? ""
        label.font = UIFont(name: headerData.titleFontName ?? "", size: CGFloat(headerData.titleFontSize ?? 17))
        label.textColor = Color.LabelBlack
        headerView.addSubview(label)

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 { return }
        guard let id = dashboardHeaders[indexPath.section].rowType?[indexPath.row].rawValue,
              let habitData = habitsDataManager.getHabit(forId: id)
        else {
            return
        }

        let selectedHabit = SelectedHabitData(title: habitData.title,
                                              frequency: Int(habitData.frequency),
                                              startTime: (habitData.startTime ?? Date())
                                                  .formatDateToString(inFormat: .time12Hour),
                                              endTime: (habitData.endTime ?? Date())
                                                  .formatDateToString(inFormat: .time12Hour),
                                              id: Int(habitData.id),
                                              isEnabled: habitData.isEnabled)
        updateHabit(forActivity: Constants.kHabitClicked, selectedHabit: selectedHabit, andSource: .habitdashboard)
        route(to: Constants.kHabitDetailViewController, withData: habitData)
    }
}

// MARK: - --UITABLEVIEWDATASOURCE--

extension DashboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dashboardHeaders.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dashboardHeaders[section].rowType?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kHabitTableViewCell,
                                                       for: indexPath) as? HabitTableViewCell,
            let id = dashboardHeaders[indexPath.section].rowType?[indexPath.row].rawValue,
            let habitData = habitsDataManager.getHabit(forId: id)
        else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.actionDelegate = self
        cell.habitData = habitData
        cell.fillHabitsData()
        return cell
    }
}

// MARK: - Protocol - DashboardActionHandler

extension DashboardViewController: DashboardActionHandler {
    func toggleHabit(toValue isEnabled: Bool, habitData: SelectedHabitData) {
        updateHabit(forActivity: isEnabled ? Constants.kHabitEnabled : Constants.kHabitDisabled,
                    selectedHabit: habitData, andSource: .habitdashboard)
    }

    func logoutUser() {
        profileViewModel.logoutUser()
        if isSourceLogin {
            navigationController?.popToRootViewController(animated: true)
        } else {
            navigationController?.setViewControllers([LoginViewController.newInstance()], animated: true)
        }
    }

    func loginUser() {
        navigationController?.popToRootViewController(animated: true)
    }

    func switchWorkspace() {
        route(to: Constants.kSwitchWorkspaceViewController)
    }
}
