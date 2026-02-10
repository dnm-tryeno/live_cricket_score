import Flutter
import UIKit
import google_mobile_ads

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register Flutter plugins FIRST (required for Google Mobile Ads plugin)
    GeneratedPluginRegistrant.register(with: self)
    
    // Register native ad factory for iOS AFTER plugin registration
    let nativeAdFactory = NativeAdFactory()
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
      self,
      factoryId: "listTile",
      nativeAdFactory: nativeAdFactory
    )
    
    print("✅ iOS Native Ad Factory registered with ID: listTile")
    
    // Call super implementation
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    return result
  }
}

// iOS Native Ad Factory
class NativeAdFactory: FLTNativeAdFactory {
  func createNativeAd(
    _ nativeAd: NativeAd,
    customOptions: [AnyHashable : Any]? = nil
  ) -> NativeAdView {
    print("📱 iOS: Creating native ad view with factory ID: listTile")
    
    let nativeAdView = NativeAdView()
    nativeAdView.translatesAutoresizingMaskIntoConstraints = false
    
    // Set background color and ensure it's visible
    nativeAdView.backgroundColor = UIColor(red: 0.06, green: 0.11, blue: 0.15, alpha: 1.0) // #0F1D26
    nativeAdView.isHidden = false
    nativeAdView.alpha = 1.0
    nativeAdView.clipsToBounds = true
    
    // Create main container
    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.backgroundColor = UIColor(red: 0.06, green: 0.11, blue: 0.15, alpha: 1.0)
    containerView.isHidden = false
    containerView.alpha = 1.0
    containerView.clipsToBounds = true
    
    // Icon view (left side)
    let iconView = UIImageView()
    iconView.translatesAutoresizingMaskIntoConstraints = false
    iconView.contentMode = .scaleAspectFit
    iconView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    iconView.layer.cornerRadius = 8
    iconView.clipsToBounds = true
    iconView.isHidden = false // Start visible
    iconView.alpha = 1.0 // Ensure fully opaque
    
    // Title label
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    titleLabel.textColor = .white
    titleLabel.numberOfLines = 2
    titleLabel.isHidden = false // Start visible
    titleLabel.alpha = 1.0
    titleLabel.backgroundColor = .clear // Ensure background is clear
    
    // Body label
    let bodyLabel = UILabel()
    bodyLabel.translatesAutoresizingMaskIntoConstraints = false
    bodyLabel.font = UIFont.systemFont(ofSize: 14)
    bodyLabel.textColor = .lightGray
    bodyLabel.numberOfLines = 3
    bodyLabel.isHidden = false // Start visible
    bodyLabel.alpha = 1.0
    bodyLabel.backgroundColor = .clear
    
    // CTA button
    let ctaButton = UIButton(type: .system)
    ctaButton.translatesAutoresizingMaskIntoConstraints = false
    ctaButton.backgroundColor = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0) // Orange
    ctaButton.setTitleColor(.white, for: .normal)
    ctaButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    ctaButton.layer.cornerRadius = 6
    ctaButton.isHidden = false // Start visible
    ctaButton.alpha = 1.0
    
    // Advertiser label
    let advertiserLabel = UILabel()
    advertiserLabel.translatesAutoresizingMaskIntoConstraints = false
    advertiserLabel.font = UIFont.systemFont(ofSize: 11)
    advertiserLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    advertiserLabel.isHidden = false // Start visible
    advertiserLabel.alpha = 1.0
    advertiserLabel.backgroundColor = .clear
    
    // Add views to container FIRST
    containerView.addSubview(iconView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(bodyLabel)
    containerView.addSubview(ctaButton)
    containerView.addSubview(advertiserLabel)
    
    // THEN assign to nativeAdView properties (required by SDK)
    nativeAdView.iconView = iconView
    nativeAdView.headlineView = titleLabel
    nativeAdView.bodyView = bodyLabel
    nativeAdView.callToActionView = ctaButton
    nativeAdView.advertiserView = advertiserLabel
    
    // Set constraints
    NSLayoutConstraint.activate([
      // Icon constraints
      iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
      iconView.widthAnchor.constraint(equalToConstant: 60),
      iconView.heightAnchor.constraint(equalToConstant: 60),
      
      // Title constraints
      titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
      
      // Body constraints
      bodyLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
      bodyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      
      // CTA button constraints
      ctaButton.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
      ctaButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
      ctaButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
      ctaButton.heightAnchor.constraint(equalToConstant: 32),
      
      // Advertiser constraints
      advertiserLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
      advertiserLabel.topAnchor.constraint(equalTo: ctaButton.bottomAnchor, constant: 4),
      advertiserLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
      
      // Container constraints
      containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
    ])
    
    // Add container to native ad view
    nativeAdView.addSubview(containerView)
    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
      containerView.topAnchor.constraint(equalTo: nativeAdView.topAnchor),
      containerView.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor)
    ])
    
    // IMPORTANT: Set native ad FIRST (this registers the views with the SDK)
    // The SDK will automatically populate views when nativeAd is set
    nativeAdView.nativeAd = nativeAd
    print("📱 iOS: Native ad assigned to view")
    
    // Log native ad data for debugging
    print("📱 iOS: Native ad data - Headline: \(nativeAd.headline ?? "nil")")
    print("📱 iOS: Native ad data - Body: \(nativeAd.body?.prefix(50) ?? "nil")")
    print("📱 iOS: Native ad data - CTA: \(nativeAd.callToAction ?? "nil")")
    print("📱 iOS: Native ad data - Advertiser: \(nativeAd.advertiser ?? "nil")")
    print("📱 iOS: Native ad data - Icon: \(nativeAd.icon != nil ? "present" : "nil")")
    
    // Force initial layout
    nativeAdView.setNeedsLayout()
    nativeAdView.layoutIfNeeded()
    containerView.setNeedsLayout()
    containerView.layoutIfNeeded()
    
    // Manually populate views AFTER setting nativeAd - ensure they're visible
    if let headline = nativeAd.headline {
      titleLabel.text = headline
      titleLabel.isHidden = false
      titleLabel.alpha = 1.0
      print("📱 iOS: Headline set: \(headline)")
    } else {
      titleLabel.text = "Test Headline" // Fallback for debugging
      titleLabel.isHidden = false
      print("⚠️ iOS: No headline in native ad - using fallback")
    }
    
    if let body = nativeAd.body {
      bodyLabel.text = body
      bodyLabel.isHidden = false
      bodyLabel.alpha = 1.0
      print("📱 iOS: Body set: \(body.prefix(50))...")
    } else {
      bodyLabel.text = "Test body text for native ad" // Fallback for debugging
      bodyLabel.isHidden = false
      print("⚠️ iOS: No body in native ad - using fallback")
    }
    
    if let cta = nativeAd.callToAction {
      ctaButton.setTitle(cta, for: .normal)
      ctaButton.isHidden = false
      ctaButton.alpha = 1.0
      print("📱 iOS: CTA set: \(cta)")
    } else {
      ctaButton.setTitle("Install", for: .normal) // Fallback for debugging
      ctaButton.isHidden = false
      print("⚠️ iOS: No CTA in native ad - using fallback")
    }
    
    if let advertiser = nativeAd.advertiser {
      advertiserLabel.text = advertiser
      advertiserLabel.isHidden = false
      advertiserLabel.alpha = 1.0
      print("📱 iOS: Advertiser set: \(advertiser)")
    } else {
      advertiserLabel.text = "Advertiser" // Fallback for debugging
      advertiserLabel.isHidden = false
      print("⚠️ iOS: No advertiser in native ad - using fallback")
    }
    
    if let icon = nativeAd.icon {
      iconView.image = icon.image
      iconView.isHidden = false
      iconView.alpha = 1.0
      print("📱 iOS: Icon set")
    } else {
      // Create a placeholder icon for debugging
      iconView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
      iconView.isHidden = false
      iconView.alpha = 1.0
      print("⚠️ iOS: No icon in native ad - showing placeholder")
    }
    
    // Force all views to be visible and opaque
    titleLabel.isHidden = false
    bodyLabel.isHidden = false
    ctaButton.isHidden = false
    advertiserLabel.isHidden = false
    iconView.isHidden = false
    
    titleLabel.alpha = 1.0
    bodyLabel.alpha = 1.0
    ctaButton.alpha = 1.0
    advertiserLabel.alpha = 1.0
    iconView.alpha = 1.0
    
    // Use DispatchQueue.main.async (similar to Android's post) to ensure views are rendered
    // This ensures the layout happens after the view hierarchy is fully set up
    // Populate views AFTER nativeAd is set, in async block
    DispatchQueue.main.async {
      // Re-populate views to ensure they're set (SDK might have cleared them)
      if let headline = nativeAd.headline {
        titleLabel.text = headline
        print("📱 iOS: Re-set headline in async: \(headline)")
      }
      if let body = nativeAd.body {
        bodyLabel.text = body
        print("📱 iOS: Re-set body in async")
      }
      if let cta = nativeAd.callToAction {
        ctaButton.setTitle(cta, for: .normal)
        print("📱 iOS: Re-set CTA in async: \(cta)")
      }
      if let advertiser = nativeAd.advertiser {
        advertiserLabel.text = advertiser
        print("📱 iOS: Re-set advertiser in async")
      }
      if let icon = nativeAd.icon {
        iconView.image = icon.image
        print("📱 iOS: Re-set icon in async")
      }
      
      // Ensure all views are visible and opaque
      titleLabel.isHidden = false
      bodyLabel.isHidden = false
      ctaButton.isHidden = false
      advertiserLabel.isHidden = false
      iconView.isHidden = false
      containerView.isHidden = false
      nativeAdView.isHidden = false
      
      titleLabel.alpha = 1.0
      bodyLabel.alpha = 1.0
      ctaButton.alpha = 1.0
      advertiserLabel.alpha = 1.0
      iconView.alpha = 1.0
      containerView.alpha = 1.0
      nativeAdView.alpha = 1.0
      
      // Bring views to front
      containerView.bringSubviewToFront(titleLabel)
      containerView.bringSubviewToFront(bodyLabel)
      containerView.bringSubviewToFront(ctaButton)
      containerView.bringSubviewToFront(advertiserLabel)
      containerView.bringSubviewToFront(iconView)
      
      // Force layout update again
      nativeAdView.setNeedsLayout()
      nativeAdView.layoutIfNeeded()
      containerView.setNeedsLayout()
      containerView.layoutIfNeeded()
      
      // Force update each view
      titleLabel.setNeedsLayout()
      titleLabel.layoutIfNeeded()
      bodyLabel.setNeedsLayout()
      bodyLabel.layoutIfNeeded()
      ctaButton.setNeedsLayout()
      ctaButton.layoutIfNeeded()
      
      print("✅ iOS: Native ad view layout updated in async block")
      print("📱 iOS: Title text: \(titleLabel.text ?? "nil"), hidden: \(titleLabel.isHidden), alpha: \(titleLabel.alpha)")
      print("📱 iOS: Body text: \(bodyLabel.text ?? "nil"), hidden: \(bodyLabel.isHidden), alpha: \(bodyLabel.alpha)")
      
      // Delayed layout update (similar to Android's postDelayed)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        nativeAdView.setNeedsLayout()
        nativeAdView.layoutIfNeeded()
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
        print("✅ iOS: Native ad view final layout update complete")
        print("📱 iOS: Final check - Title visible: \(!titleLabel.isHidden), Body visible: \(!bodyLabel.isHidden)")
      }
    }
    
    print("✅ iOS: Native ad view created and configured")
    
    return nativeAdView
  }
}
