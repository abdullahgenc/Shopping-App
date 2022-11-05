//
//  OnboardingViewController.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 26.10.2022.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    private let pageWidth: CGFloat = UIScreen.main.bounds.width

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var prevButton: UIButton!
    
    var currentPageNumber: Int = .zero {
        didSet {
            pageControl.currentPage = currentPageNumber
            updateScrollViewContentOffset(with: currentPageNumber)
        }
    }
    
    var onboardingViews = [OnboardingView]() {
        didSet {
            
            let numberOfPages = onboardingViews.count
            scrollView.contentSize.width = CGFloat(numberOfPages) * pageWidth
            pageControl.numberOfPages = numberOfPages

            for onboardingView in onboardingViews {
                contentView.addSubview(onboardingView)
                onboardingView.snp.makeConstraints { make in
                    make.leading.equalTo(contentView.snp.leading)
                }
            } else {
                onboardingView.snp.makeConstraints { make in
                    make.leading.equalTo(onboardingViews[onboardingViews.count-2].snp.trailing)
                    make.trailing.equalTo(contentView.snp.trailing)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        var views = [OnboardingView]()

        let firstOnboardingView = OnboardingView()
        firstOnboardingView.image = UIImage(named: "placeholder")
        firstOnboardingView.text = "First Onboarding View"
        views.append(firstOnboardingView)

        let secondOnboardingView = OnboardingView()
        secondOnboardingView.image = UIImage(named: "placeholder")
        secondOnboardingView.text = "Second Onboarding View"
        views.append(secondOnboardingView)

        let thirdOnboardingView = OnboardingView()
        thirdOnboardingView.tag = 3
        thirdOnboardingView.image = UIImage(named: "placeholder")
        thirdOnboardingView.text = "Third Onboarding View"
        views.append(thirdOnboardingView)

        onboardingViews = views

        let defaults = UserDefaults.standard
        let isOnboardingScreenViewedKey = "isOnboardingScreenViewed"
        if defaults.bool(forKey: isOnboardingScreenViewedKey) == false {
            defaults.set(true, forKey: isOnboardingScreenViewedKey)
        } else {
            goToAuth()
        }
    }

    @IBAction func didTapNextButton(_ sender: UIButton) {
        if currentPageNumber < onboardingViews.count - 1 {
            currentPageNumber += 1
        }
        else {
            goToAuth()
        }
    }
    
    @IBAction func didTapPrevButton(_ sender: UIButton) {
        if currentPageNumber > 0 {
            currentPageNumber -= 1
        }
    }
    
    @IBAction func didTapSkipButton(_ sender: UIButton) {
        goToAuth()
    }
    
    @IBAction func didPageControlValueChanged(_ sender: UIPageControl) {
        updateScrollViewContentOffset(with: sender.currentPage)
    }
    
    private func updateScrollViewContentOffset(with pageNumber: Int) {
        
        if pageNumber == onboardingViews.count - 1 {
            nextButton.setTitle("Done", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
        
        if pageNumber == .zero {
            prevButton.isHidden = true
        } else {
            prevButton.isHidden = false
        }
        
        let contentOffset = CGPoint(x: pageWidth * CGFloat(pageNumber), y: .zero)
        scrollView.setContentOffset(contentOffset, animated: true)
    }
    
    private func goToAuth() {
        navigationController?.pushViewController(AuthViewController(viewModel: AuthViewModel()), animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        currentPageNumber = currentPage
    }
}
