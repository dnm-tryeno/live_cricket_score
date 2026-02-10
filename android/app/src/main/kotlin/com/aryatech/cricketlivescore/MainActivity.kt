package com.aryatech.cricketlivescore

import android.content.Context
import android.graphics.Color
import android.net.ConnectivityManager
import android.telephony.TelephonyManager
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.ImageView
import android.widget.Button
import android.view.View
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.aryatech.speedtest/network_type"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Native Ad Factory registration for Flutter-side NativeAdWidget (factoryId: "listTile")
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "listTile",
            ListTileNativeAdFactory(this)
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            android.util.Log.d("NetworkType", "📡 Method channel called: ${call.method}")
            when (call.method) {
                "getNetworkType" -> {
                    val networkType = getNetworkType()
                    android.util.Log.d("NetworkType", "📡 Returning network type: $networkType")
                    result.success(networkType)
                }
                else -> {
                    android.util.Log.d("NetworkType", "📡 Method not implemented: ${call.method}")
                    result.notImplemented()
                }
            }
        }
    }

    private fun getNetworkType(): String {
        return try {
            android.util.Log.d("NetworkType", "📡 Getting network type...")

            val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

            @Suppress("DEPRECATION")
            val networkInfo = connectivityManager.activeNetworkInfo

            if (networkInfo == null || !networkInfo.isConnected) {
                android.util.Log.d("NetworkType", "📡 No active network connection")
                return "Mobile"
            }

            android.util.Log.d("NetworkType", "📡 Network type: ${networkInfo.type}")
            android.util.Log.d("NetworkType", "📡 Network subtype: ${networkInfo.subtype}")
            android.util.Log.d("NetworkType", "📡 Network subtype name: ${networkInfo.subtypeName}")

            val subtype = networkInfo.subtype

            when (subtype) {
                TelephonyManager.NETWORK_TYPE_GPRS,
                TelephonyManager.NETWORK_TYPE_EDGE,
                TelephonyManager.NETWORK_TYPE_CDMA,
                TelephonyManager.NETWORK_TYPE_1xRTT,
                TelephonyManager.NETWORK_TYPE_IDEN -> {
                    android.util.Log.d("NetworkType", "📡 ✅ Detected: 2G")
                    "2G"
                }
                TelephonyManager.NETWORK_TYPE_UMTS,
                TelephonyManager.NETWORK_TYPE_EVDO_0,
                TelephonyManager.NETWORK_TYPE_EVDO_A,
                TelephonyManager.NETWORK_TYPE_HSDPA,
                TelephonyManager.NETWORK_TYPE_HSUPA,
                TelephonyManager.NETWORK_TYPE_HSPA,
                TelephonyManager.NETWORK_TYPE_EVDO_B,
                TelephonyManager.NETWORK_TYPE_EHRPD,
                TelephonyManager.NETWORK_TYPE_HSPAP -> {
                    android.util.Log.d("NetworkType", "📡 ✅ Detected: 3G")
                    "3G"
                }
                TelephonyManager.NETWORK_TYPE_LTE -> {
                    android.util.Log.d("NetworkType", "📡 ✅ Detected: 4G (LTE)")
                    "4G"
                }
                20 -> {
                    android.util.Log.d("NetworkType", "📡 ✅ Detected: 5G (NR)")
                    "5G"
                }
                else -> {
                    android.util.Log.d("NetworkType", "📡 ⚠️ Unknown subtype: $subtype (${networkInfo.subtypeName})")
                    "Mobile"
                }
            }
        } catch (e: Exception) {
            android.util.Log.e("NetworkType", "📡 ❌ Exception: ${e.message}", e)
            e.printStackTrace()
            "Mobile"
        }
    }
}

// Complete NativeAdFactory for "listTile" layout with all required views
// This ensures AdMob's validator accepts it and shows actual ad content instead of just dialog
class ListTileNativeAdFactory(private val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = NativeAdView(context)
        adView.setBackgroundColor(Color.parseColor("#0F1D26"))
        adView.visibility = View.VISIBLE
        adView.layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )

        // Main horizontal container
        val mainContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            setPadding(24, 24, 24, 24)
            visibility = View.VISIBLE
            minimumHeight = 200
        }

        // Icon view (required by AdMob validator) - left side
        val iconView = ImageView(context).apply {
            layoutParams = LinearLayout.LayoutParams(120, 120).apply {
                rightMargin = 16
            }
            scaleType = ImageView.ScaleType.FIT_CENTER
            setBackgroundColor(Color.parseColor("#1a1a1a"))
            visibility = View.VISIBLE
            minimumWidth = 120
            minimumHeight = 120
        }
        adView.iconView = iconView
        mainContainer.addView(iconView)

        // Right side vertical container
        val rightContainer = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                0,
                ViewGroup.LayoutParams.WRAP_CONTENT,
                1.0f
            )
            visibility = View.VISIBLE
        }

        // Headline (title) - required
        val titleView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = 8
            }
            textSize = 18f
            setTextColor(Color.WHITE)
            maxLines = 2
            ellipsize = android.text.TextUtils.TruncateAt.END
            setTypeface(null, android.graphics.Typeface.BOLD)
            visibility = View.VISIBLE
            minHeight = 48
        }
        adView.headlineView = titleView
        rightContainer.addView(titleView)

        // Body text - required for complete native ads
        val bodyView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = 12
            }
            textSize = 14f
            setTextColor(Color.parseColor("#CCCCCC"))
            maxLines = 3
            ellipsize = android.text.TextUtils.TruncateAt.END
            visibility = View.VISIBLE
            minHeight = 60
        }
        adView.bodyView = bodyView
        rightContainer.addView(bodyView)

        // Call to action button - required for complete native ads
        val callToActionView = Button(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = 8
            }
            setTextColor(Color.WHITE)
            setBackgroundColor(Color.parseColor("#FF6B00"))
            textSize = 14f
            setPadding(32, 16, 32, 16)
            elevation = 0f
            visibility = View.VISIBLE
            minWidth = 120
            minHeight = 48
        }
        adView.callToActionView = callToActionView
        rightContainer.addView(callToActionView)

        // Advertiser name
        val advertiserView = TextView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            textSize = 11f
            setTextColor(Color.parseColor("#999999"))
            visibility = View.VISIBLE
            minHeight = 24
        }
        adView.advertiserView = advertiserView
        rightContainer.addView(advertiserView)

        // Add right container to main container
        mainContainer.addView(rightContainer)

        // Add main container to ad view
        adView.addView(mainContainer)

        // Log native ad data for debugging
        android.util.Log.d("NativeAdFactory", "📢 Creating native ad view...")
        android.util.Log.d("NativeAdFactory", "Headline: ${nativeAd.headline}")
        android.util.Log.d("NativeAdFactory", "Body: ${nativeAd.body}")
        android.util.Log.d("NativeAdFactory", "CTA: ${nativeAd.callToAction}")
        android.util.Log.d("NativeAdFactory", "Advertiser: ${nativeAd.advertiser}")
        android.util.Log.d("NativeAdFactory", "Icon: ${nativeAd.icon != null}")
        android.util.Log.d("NativeAdFactory", "StarRating: ${nativeAd.starRating}")
        android.util.Log.d("NativeAdFactory", "Price: ${nativeAd.price}")
        android.util.Log.d("NativeAdFactory", "Store: ${nativeAd.store}")
        
        // Set all required views BEFORE calling setNativeAd
        // AdMob's setNativeAd() will automatically populate these views
        adView.setNativeAd(nativeAd)
        
        // After setNativeAd, manually populate views to ensure content is displayed
        // Sometimes AdMob SDK doesn't populate views immediately, so we do it manually
        adView.post {
            try {
                android.util.Log.d("NativeAdFactory", "📊 After setNativeAd - Populating views manually...")
                
                // Manually populate headline
                nativeAd.headline?.let {
                    titleView.text = it
                    titleView.visibility = View.VISIBLE
                    android.util.Log.d("NativeAdFactory", "✅ Set headline: $it")
                }
                
                // Manually populate body
                nativeAd.body?.let {
                    bodyView.text = it
                    bodyView.visibility = View.VISIBLE
                    android.util.Log.d("NativeAdFactory", "✅ Set body: $it")
                }
                
                // Manually populate CTA
                nativeAd.callToAction?.let {
                    callToActionView.text = it
                    callToActionView.visibility = View.VISIBLE
                    android.util.Log.d("NativeAdFactory", "✅ Set CTA: $it")
                }
                
                // Manually populate advertiser
                nativeAd.advertiser?.let {
                    advertiserView.text = it
                    advertiserView.visibility = View.VISIBLE
                    android.util.Log.d("NativeAdFactory", "✅ Set advertiser: $it")
                }
                
                // Manually populate icon
                nativeAd.icon?.drawable?.let {
                    iconView.setImageDrawable(it)
                    iconView.visibility = View.VISIBLE
                    android.util.Log.d("NativeAdFactory", "✅ Set icon drawable")
                }
                
                // Ensure all views are visible
                titleView.visibility = View.VISIBLE
                bodyView.visibility = View.VISIBLE
                callToActionView.visibility = View.VISIBLE
                advertiserView.visibility = View.VISIBLE
                iconView.visibility = View.VISIBLE
                
                // Force layout refresh multiple times to ensure rendering
                adView.requestLayout()
                adView.invalidate()
                mainContainer.requestLayout()
                mainContainer.invalidate()
                
                // Post again to ensure views are rendered
                adView.postDelayed({
                    adView.requestLayout()
                    adView.invalidate()
                    android.util.Log.d("NativeAdFactory", "✅ Native ad view setup complete - Final layout")
                }, 100)
                
                android.util.Log.d("NativeAdFactory", "✅ Native ad view setup complete")
            } catch (e: Exception) {
                android.util.Log.e("NativeAdFactory", "❌ Error in post setup: ${e.message}", e)
                e.printStackTrace()
            }
        }

        return adView
    }
}
