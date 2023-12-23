protocol MainPageViewControllerDelegate: AnyObject {
    func setPage(page: Int)
}
import UIKit

final class MainPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, MainPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    let bottomView = UIView()
    let pageControl = UIPageControl()
    let placesButton = UIButton()
    let initialPage = 0
    var viewModel: MainPageViewModelProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getCityArray()
        viewModel?.addObserver()
        setupUI()
        bindViewModel()
    }
    func setPage(page: Int) {
        pageControl.currentPage = page
        setViewControllers([pages[page]], direction: .forward, animated: true)
    }
    private func bindViewModel() {
        viewModel?.updateClosure = { [weak self] in
            guard let self = self else { return }
            self.setupUI()
        }
    }
    private func setupUI() {
        pages = []
        guard let numLoc = viewModel?.weatherData.count else { return }
        if numLoc == 0 {
            let gpsPage = WeatherViewController.instantiate()
            let gpsViewModel = WeatherViewModel()
            gpsViewModel.location = "Current"
            gpsViewModel.locale = viewModel?.locale
            gpsPage.viewModel = gpsViewModel
            self.pages.append(gpsPage)
        } else {
            guard let data = viewModel?.weatherData else { return}
            for (i, v) in data.enumerated() {
                if i == 0 {
                    let gpsPage = WeatherViewController.instantiate()
                    let gpsViewModel = WeatherViewModel()
                    gpsViewModel.location = "Current"
                    gpsViewModel.locale = viewModel?.locale
                    gpsPage.viewModel = gpsViewModel
                    self.pages.append(gpsPage)
                } else {
                    let page = WeatherViewController.instantiate()
                    let pageModel = WeatherViewModel()
                    pageModel.locale = viewModel?.locale
                    pageModel.coords = Coords(lon: v.lon, lat: v.lat)
                    pageModel.location = v.locationID ?? ""
                    page.viewModel = pageModel
                    self.pages.append(page)
                }
            }
            
            
            setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        }
        
        
        self.dataSource = self
        self.delegate = self
        
        
        self.bottomView.frame = CGRect()
        self.bottomView.backgroundColor = UIColor(cgColor: CGColor(red: 83/255, green: 146/255, blue: 189/255, alpha: 1))
        self.view.addSubview(self.bottomView)
        
        self.bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        self.bottomView.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.addTarget(self, action: #selector(pageControlHandle), for: .valueChanged)
        
        self.placesButton.frame = CGRect()
        self.placesButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        self.placesButton.tintColor = .white
        self.placesButton.addTarget(self, action: #selector(openLocations), for: .touchUpInside)
        self.bottomView.addSubview(self.placesButton)
        
        self.placesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.bottomView.heightAnchor.constraint(equalToConstant: 70),
            
            self.pageControl.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10),
            self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20),
            self.pageControl.heightAnchor.constraint(equalToConstant: 20),
            self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.placesButton.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10),
            self.placesButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func pageControlHandle(sender: UIPageControl){
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true)
    }
    
    @objc func openLocations() {
        viewModel?.showLocations(viewController: self)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)!

        guard currentIndex > 0 else {
            return nil
        }
        pageControl.currentPage = currentIndex - 1
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.firstIndex(of: viewController)!

        guard currentIndex < pages.count - 1 else {
            return nil
        }
        pageControl.currentPage = currentIndex + 1
        return pages[currentIndex + 1]
    }
    
}

extension MainPageViewController: Storyboarded {
    static func containingStoryboard() -> Storyboard {
        .MainPageView
    }
}
