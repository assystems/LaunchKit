// The Swift Programming Language
// https://docs.swift.org/swift-book
import UIKit
import StoreKit

public var LaunchKit: LaunchKitProtocol = LaunchKitImpl.shared

public protocol LaunchKitProtocol {
    
    /// 初回起動時
    var isFirstLaunch: Bool { get }
    
    /// 初回or前回起動時とバージョンが変化している場合はtrue
    var isVersionChanged: Bool { get }
    
    /// 指定した回数時にレビューリクエストを表示する
    /// アプリ起動時に１回だけ呼び出す
    /// - Parameter launchCount: 起動回数に達した時に表示
    func showReviewRequestIfNeeded(skipLaunchCount: Int)
    
}

public struct LaunchKitImpl: LaunchKitProtocol {
    
    private enum UserDefaultsKeys: String {
        case launchCount
        case version
        var value: String { rawValue }
    }
    
    fileprivate static var shared: LaunchKitProtocol = LaunchKitImpl()
    
    public var isFirstLaunch: Bool {
        launchCount == 1
    }
    
    public var isVersionChanged: Bool {
        newVersion != oldVersion
    }
    
    private let userDefaults = UserDefaults(suiteName: "jp.ass.LaunchKit")!
    private let launchCount: Int
    private let newVersion: Version?
    private let oldVersion: Version?

    private init() {
        // 起動回数更新
        let newLaunchCount = userDefaults.integer(forKey: UserDefaultsKeys.launchCount.value) + 1
        userDefaults.set(newLaunchCount, forKey: UserDefaultsKeys.launchCount.value)
        launchCount = newLaunchCount
        
        // Version情報
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        newVersion = Version(versionString: appVersion)
        let savedVersion = userDefaults.string(forKey: UserDefaultsKeys.version.value) ?? ""
        oldVersion = Version(versionString: savedVersion)
        userDefaults.set(appVersion, forKey: UserDefaultsKeys.version.value)
    }
    
    public func showReviewRequestIfNeeded(skipLaunchCount: Int) {
        if launchCount > skipLaunchCount {
            showSKStoreReviewController()
        }
    }
    
    private func showSKStoreReviewController() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
