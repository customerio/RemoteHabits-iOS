import UIKit

class RHDashboardViewController: RHBaseViewController {
    static func newInstance() -> RHDashboardViewController {
        UIStoryboard.getViewController(identifier: RHConstants.kDashboardViewController)
    }

    // MARK: - --OUTLETS--

    @IBOutlet var dashboardTableView: UITableView!

    // MARK: - --VARIABLES--

    var dashboardData = UserHabit()
    var isSourceLogin: Bool = false
    var profileViewModel = DI.shared.profileViewModel
    var trackerViewModel = DI.shared.trackerViewModel

    // MARK: - --LIFECYCLE METHODS--

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar(title: RHConstants.kEmptyValue, hideBack: true, showLogo: true)
        addDefaultBackground()
        setupDashboardTableView()
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    // MARK: - --FUNCTIONS--

    func setupDashboardTableView() {
        dashboardData = RHStubData().getStubData()

        // HabitTableViewCell move to constant file
        dashboardTableView.register(UINib(nibName: RHConstants.kHabitTableViewCell, bundle: nil),
                                    forCellReuseIdentifier: RHConstants.kHabitTableViewCell)
        dashboardTableView.rowHeight = UITableView.automaticDimension
        dashboardTableView.estimatedRowHeight = 80
    }

    func route(withData: HabitData) {
        let viewController = RHHabitDetailViewController.newInstance()
        viewController.habitDetailData = withData
        let navigation = UINavigationController(rootViewController: viewController)
        present(navigation, animated: true, completion: nil)
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

extension RHDashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        97.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 97))
        headerView.backgroundColor = view.backgroundColor
        let headerData = dashboardData[section].first?.key
        let label = UILabel()
        label.frame = CGRect(x: 16, y: 5, width: headerView.frame.width - 20, height: headerView.frame.height - 10)
        if section != 0 {
            label.frame = CGRect(x: 16, y: 60, width: headerView.frame.width - 20, height: 26)
        }

        label.text = headerData?.headerTitle
        label.font = UIFont(name: headerData?.titleFontName ?? RHConstants.kEmptyValue,
                            size: CGFloat(headerData?.titleFontSize ?? 17))
        label.textColor = .black

        headerView.addSubview(label)

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 { return }

        guard let habitData = dashboardData[indexPath.section].first?.value[indexPath.row],
              let habitName = habitData.title
        else {
            // Show error

            return
        }

        let selectedHabit = SelectedHabitData(title: habitName, frequency: habitData.habitDetail?.frequency,
                                              startTime: habitData.habitDetail?.startTime,
                                              endTime: habitData.habitDetail?.endTime)
        trackerViewModel.trackHabitActivity(withName: RHConstants.kHabitClicked, forHabit: selectedHabit)
        route(withData: habitData)
    }
}

// MARK: - --UITABLEVIEWDATASOURCE--

extension RHDashboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dashboardData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dashboardData[section].first?.value.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RHConstants.kHabitTableViewCell,
                                                       for: indexPath) as? HabitTableViewCell
        else {
            return UITableViewCell()
        }

        let habitData = dashboardData[indexPath.section].first?.value[indexPath.row]
        cell.selectionStyle = .none
        cell.actionDelegate = self
        cell.habitData = habitData
        cell.fillData()

        return cell
    }
}

// MARK: - Protocol - RHDashboardActionHandler

extension RHDashboardViewController: RHDashboardActionHandler {
    func toggleHabit(toValue isEnabled: Bool, habitData: SelectedHabitData) {
        trackerViewModel
            .trackHabitActivity(withName: isEnabled ? RHConstants.kHabitEnabled : RHConstants.kHabitDisabled,
                                forHabit: habitData)
    }

    func logoutUser() {
        profileViewModel.logoutUser()

        if isSourceLogin {
            navigationController?.popToRootViewController(animated: true)
        } else {
            navigationController?.setViewControllers([RHLoginViewController.newInstance()], animated: true)
        }
    }

    func loginUser() {
        navigationController?.popToRootViewController(animated: true)
    }

    func switchWorkspace() {
        let viewController = RHSwitchWorkspaceViewController.newInstance()
        let navigation = UINavigationController(rootViewController: viewController)
        present(navigation, animated: true, completion: nil)
    }
}
