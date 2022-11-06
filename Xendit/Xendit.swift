//
//  Xendit.swift
//  Xendit
//
//  Created by Maxim Bolotov on 3/15/17.
//
//

import Foundation
import CardinalMobile


@objcMembers
@objc(Xendit) open class Xendit: NSObject {
    
    // MARK: - Public methods
    
    // Publishable key
    public static var publishableKey: String?
    
    // WKWebView configuration
    public struct XenditWebViewConfiguration {
        /**
         * Controls whether navigation is limited to app-bound domains on iOS
         *
         * This field is ignored on iOS before iOS 14.0
         *
         * By default `limitsNavigationsToAppBoundDomains` is false
         */
        public var limitsNavigationsToAppBoundDomains: Bool = false
    }
    public struct XenditConfiguration {
        public var webView: XenditWebViewConfiguration
    }
    
    public static let defaultConfig = XenditConfiguration(webView: XenditWebViewConfiguration(limitsNavigationsToAppBoundDomains: false))
    
    public static var config = defaultConfig
    
    private static var cardinalSession: CardinalSession!
    private static var isSetup = false
    
    // Create token method with billing details and customer object
    public static func createToken(fromViewController: UIViewController, tokenizationRequest: XenditTokenizationRequest, onBehalfOf: String?, completion:@escaping (_ : XenditCCToken?, _ : XenditError?) -> Void) {
        XDTCards.setup(publishableKey: publishableKey!, config: config)
        XDTCards.createToken(fromViewController: fromViewController, tokenizationRequest: tokenizationRequest, onBehalfOf: onBehalfOf, completion: completion)
    }
    
    public static func createAuthentication(fromViewController: UIViewController, authenticationRequest: XenditAuthenticationRequest, onBehalfOf: String?, completion:@escaping (_ : XenditAuthentication?, _ : XenditError?) -> Void) {
        XDTCards.setup(publishableKey: publishableKey!, config: config)
        let tokenId = authenticationRequest.tokenId
        let amount = authenticationRequest.amount
        let customer = authenticationRequest.customer
        let currency = authenticationRequest.currency
        XDTCards.createAuthentication(fromViewController: fromViewController, tokenId: tokenId, amount: amount, currency: currency, onBehalfOf: onBehalfOf, customer: customer, cardCvn: authenticationRequest.cardCvn, completion: completion)
    }
    
    @available(*, deprecated, message: "Use createToken(UIViewController, XenditTokenizationRequest, String, Callback) instead")
    public static func createToken(fromViewController: UIViewController, cardData: CardData!, shouldAuthenticate: Bool, onBehalfOf: String, completion:@escaping (_ : XenditCCToken?, _ : XenditError?) -> Void) {
        XDTCards.setup(publishableKey: publishableKey!, config: config)
        let tokenizationRequest = XenditTokenizationRequest(cardData: cardData, shouldAuthenticate: shouldAuthenticate)
        XDTCards.createToken(fromViewController: fromViewController, tokenizationRequest: tokenizationRequest, onBehalfOf: onBehalfOf, completion: completion)
    }
    
    @available(*, deprecated, message: "Use createToken(UIViewController, XenditTokenizationRequest, String, Callback) instead")
    public static func createToken(fromViewController: UIViewController, cardData: CardData!, completion:@escaping (_ : XenditCCToken?, _ : XenditError?) -> Void) {
        XDTCards.setup(publishableKey: publishableKey!, config: config)
        let tokenizationRequest = XenditTokenizationRequest(cardData: cardData, shouldAuthenticate: true)
        XDTCards.createToken(fromViewController: fromViewController, tokenizationRequest: tokenizationRequest, onBehalfOf: nil, completion: completion)
    }
    
    @available(*, deprecated, message: "Use createToken(UIViewController, XenditTokenizationRequest, String, Callback) instead")
    public static func createToken(fromViewController: UIViewController, cardData: CardData!, shouldAuthenticate: Bool!, completion:@escaping (_ : XenditCCToken?, _ : XenditError?) -> Void) {
        XDTCards.setup(publishableKey: publishableKey!, config: config)
        let tokenizationRequest = XenditTokenizationRequest(cardData: cardData, shouldAuthenticate: shouldAuthenticate)
        XDTCards.createToken(fromViewController: fromViewController, tokenizationRequest: tokenizationRequest, onBehalfOf: nil, completion: completion)
    }
    
    @available(*, deprecated, message: "Use createAuthentication(UIViewController, XenditAuthenticationRequest, Callback) instead")
    public static func createAuthentication(fromViewController: UIViewController, tokenId: String, amount: NSNumber, onBehalfOf: String, completion:@escaping (_ : XenditAuthentication?, _ : XenditError?) -> Void) {
        XDTCards.setup(publishableKey: publishableKey!, config: config)
        XDTCards.createAuthentication(fromViewController: fromViewController, tokenId: tokenId, amount: amount, currency: nil, onBehalfOf: onBehalfOf, customer: nil, cardCvn: nil, completion: completion)
    }
    
    @available(*, deprecated, message: "Use createAuthentication(UIViewController, XenditAuthenticationRequest, Callback) instead")
    public static func createAuthentication(fromViewController: UIViewController, tokenId: String, amount: NSNumber, completion:@escaping (_ : XenditAuthentication?, _ : XenditError?) -> Void) {
        XDTCards.setup(publishableKey: publishableKey!, config: config)
        XDTCards.createAuthentication(fromViewController: fromViewController, tokenId: tokenId, amount: amount, currency: nil, onBehalfOf: nil, customer: nil, cardCvn: nil, completion: completion)
    }
    
    @available(*, deprecated, message: "Use createAuthentication(UIViewController, XenditAuthenticationRequest, Callback) instead")
    public static func createAuthentication(fromViewController: UIViewController, tokenId: String, amount: NSNumber, cardCVN: String, completion:@escaping (_ : XenditAuthentication?, _ : XenditError?) -> Void) {
        XDTCards.setup(publishableKey: publishableKey!, config: config)
        XDTCards.createAuthentication(fromViewController: fromViewController, tokenId: tokenId, amount: amount, currency: nil, onBehalfOf: nil, customer: nil, cardCvn: cardCVN, completion: completion)
    }
    
    // Card data validation method
    public static func isCardNumberValid(cardNumber: String) -> Bool {
        return CreditCard.isValidCardNumber(cardNumber: cardNumber)
    }
    
    // Card expiration date validation method
    public static func isExpiryValid(cardExpirationMonth: String, cardExpirationYear: String) -> Bool {
        return CreditCard.isExpiryValid(cardExpirationMonth: cardExpirationMonth, cardExpirationYear: cardExpirationYear)
    }
    
    // Card cvn validation method
    public static func isCvnValid(creditCardCVN: String) -> Bool {
        return CreditCard.isCvnValid(creditCardCVN: creditCardCVN)
    }
    
    // Card cvn validation for card type method
    public static func isCvnValidForCardType(creditCardCVN: String, cardNumber: String) -> Bool {
        return CreditCard.isCvnValidForCardType(creditCardCVN: creditCardCVN, cardNumber: cardNumber)
    }
    
    // MARK: - Logging
    public static func setLogLevel(_ level: XenditLogLevel?) {
        Log.shared.level = level
    }
    
    public static func setLogDNALevel(_ level: ISHLogDNALevel?) {
        Log.shared.logDNALevel = level
    }
}
