import UIKit

final class WeatherViewController: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var hourlyView: UIView!
    @IBOutlet private weak var hourlyLabel: UILabel!
    @IBOutlet private weak var hourlyCollectionView: UICollectionView!
    //MARK: - Variables
    var viewModel: WeatherViewModelProtocol?
    
    let cityName = UILabel()
    let tempLabel = UILabel()
    let skyLabel = UILabel()
    let tempSkyLabel = UILabel()
    let minMaxLabel = UILabel()
    var heroSetId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        bindViewModel()
        viewModel?.getData()
        setupUI()
        backgroundImage.heroID = "back\(heroSetId)"
    }
    
    private func animateView() {
        UIView.animate(withDuration: 0.5) {
            self.cityName.layer.opacity = 1
            self.tempLabel.layer.opacity = 1
            self.skyLabel.layer.opacity = 1
            self.minMaxLabel.layer.opacity = 1
            self.tableView.layer.opacity = 1
        }
    }
    private func showNoInternetAlert() {
        if viewModel?.connection == false {
            guard let saveTime = viewModel?.saveTime else { return }
            let timeInterval = Date().timeIntervalSince(saveTime)
            let message = WeatherScreenLocalization.lastUpdate.string + " " + WeatherDateFormatter.shared.getInterval(date: timeInterval)
            let alertController = UIAlertController(title: WeatherScreenLocalization.noInternet.string, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(action)
            var rootViewController = UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .last { $0.isKeyWindow }?.rootViewController
            if let navigationController = rootViewController as? UINavigationController {
                rootViewController = navigationController.viewControllers.first
            }
            if let tabBarController = rootViewController as? UITabBarController {
                rootViewController = tabBarController.selectedViewController
            }
            rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func setupUI() {
        if viewModel?.isLoading == true {
            tempSkyLabel.layer.opacity = 0
            cityName.layer.opacity = 0
            tempLabel.layer.opacity = 0
            skyLabel.layer.opacity = 0
            minMaxLabel.layer.opacity = 0
            tableView.layer.opacity = 0
        }
        let hourNib = UINib(nibName: XibNames.hourly.name, bundle: nil)
        tableView.register(hourNib, forCellReuseIdentifier: XibNames.hourly.name)
        let weekNib = UINib(nibName: XibNames.weekly.name, bundle: nil)
        tableView.register(weekNib, forCellReuseIdentifier: XibNames.weekly.name)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 250))
        headerView.backgroundColor = .clear
        
        cityName.textColor = .white
        tempLabel.textColor = .white
        skyLabel.textColor = .white
        tempSkyLabel.textColor = .white
        minMaxLabel.textColor = .white
        
        cityName.font = cityName.font.withSize(35)
        tempSkyLabel.font = tempSkyLabel.font.withSize(25)
        tempLabel.font = UIFont.systemFont(ofSize: 120, weight: UIFont.Weight.thin)
        skyLabel.font = skyLabel.font.withSize(20)
        minMaxLabel.font = minMaxLabel.font.withSize(20)
        
        cityName.text = viewModel?.weatherData?.timezone
        tempLabel.text = String(Int(viewModel?.weatherData?.current.temp ?? 0)) + WeatherScreenLocalization.tempSign.string
        skyLabel.text = viewModel?.weatherData?.current.weather.first?.description
        tempSkyLabel.text = (tempLabel.text ?? "") + " | " + (skyLabel.text ?? "")
        minMaxLabel.text = viewModel?.getMinMax(tempArr: viewModel?.weatherData?.hourly ?? [])
        
        headerView.addSubview(cityName)
        headerView.addSubview(tempLabel)
        headerView.addSubview(tempSkyLabel)
        headerView.addSubview(skyLabel)
        headerView.addSubview(minMaxLabel)
        
        cityName.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        skyLabel.translatesAutoresizingMaskIntoConstraints = false
        tempSkyLabel.translatesAutoresizingMaskIntoConstraints = false
        minMaxLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityName.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            cityName.topAnchor.constraint(equalTo: headerView.topAnchor, constant: -12),
            
            tempLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: -12),
            
            tempSkyLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            tempSkyLabel.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: -5),
            
            skyLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            skyLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: -2),
            
            minMaxLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            minMaxLabel.topAnchor.constraint(equalTo: skyLabel.bottomAnchor, constant: 4),
        ])
        return headerView
    }
    
    
    private func bindViewModel() {
        viewModel?.updateClosure = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            guard let image = viewModel?.weatherData?.current.weather.first?.icon.getBack() else { return }
            backgroundImage.image = UIImage(named: image)
            if viewModel?.isLoading == false {
                self.animateView()
            }
            self.showNoInternetAlert()
        }
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let hourlyCell = tableView.dequeueReusableCell(withIdentifier: XibNames.hourly.name) as? HourlyTableViewCell else { return UITableViewCell() }
        hourlyCell.weatherData = viewModel?.weatherData?.hourly
        guard let weeklyCell = tableView.dequeueReusableCell(withIdentifier: XibNames.weekly.name) as? WeeklyTableViewCell else { return UITableViewCell() }
        weeklyCell.weatherData = viewModel?.weatherData?.daily
        switch indexPath.row {
            case 0:
                return hourlyCell
            default:
                return weeklyCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        250
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                return 150
            default:
                return 400
        }
    }
}

extension WeatherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        minMaxLabel.layer.opacity = 6 - Float(59 + scrollView.contentOffset.y)/10
        skyLabel.layer.opacity = 8.5 - Float(59 + scrollView.contentOffset.y)/10
        tempLabel.layer.opacity = 13.5 - Float(59 + scrollView.contentOffset.y)/10
        tempSkyLabel.layer.opacity = (13.5 - Float(59 + scrollView.contentOffset.y)/10 >= 0 ? 0 : abs(13.5 - Float(59 + scrollView.contentOffset.y)/10))
    }
}

extension WeatherViewController: Storyboarded {
    static func containingStoryboard() -> Storyboard {
        .WeatherView
    }
}
