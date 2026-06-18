//
//  PaymentHandler.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 7/3/24.
//

import Foundation
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?
    
    static let supportedNetworks: [PKPaymentNetwork] = [
        .amex, .masterCard, .girocard
    ]
    
    func shippingMethodCalculator() -> [PKShippingMethod] {
        let today = Date()
        let calendar = Calendar.current
        
        let shippingStartDate = calendar.date(byAdding: .day, value: 5, to: today)
        let shippingEndDate = calendar.date(byAdding: .day, value: 10, to: today)
        
        if let shippingEndDate = shippingEndDate,
           let shippingStartDate = shippingStartDate {
            let startComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingStartDate)
            let endComponets = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingEndDate)
            
            let shippingDelivery = PKShippingMethod(label: String(localized: "payment.delivery"), amount: NSDecimalNumber(string: "0.00"))
            shippingDelivery.dateComponentsRange = PKDateComponentsRange(start: startComponents, end: endComponets)
            shippingDelivery.detail = String(localized: "payment.deliveryDetail")
            shippingDelivery.identifier = "DELIVERY"
            
            return [shippingDelivery]
        }
        
        return []
    }
    
    func startPayment(products: [CartProduct], total: Int, completion: @escaping PaymentCompletionHandler) {
        completionHandler = completion
        
        paymentSummaryItems = []
        
        products.forEach { product in
            let item = PKPaymentSummaryItem(label: product.name, 
                                            amount: NSDecimalNumber(string: "\(product.caseAmount).00"),
                                            type: .final)
            paymentSummaryItems.append(item)
            
            let total = PKPaymentSummaryItem(label: String(localized: "payment.total"),
                                             amount: NSDecimalNumber(string: "\(total).00"),
                                             type: .final)
            paymentSummaryItems.append(total)
            
            let paymentRequest = PKPaymentRequest()
            paymentRequest.paymentSummaryItems = paymentSummaryItems
            paymentRequest.merchantIdentifier = "merchant.de.chapter.softwaremill.demos.applewatchstore"
            paymentRequest.merchantCapabilities = .threeDSecure
            paymentRequest.countryCode = "DE"
            paymentRequest.currencyCode = "EUR"
            paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
            paymentRequest.shippingType = .delivery
            paymentRequest.shippingMethods = shippingMethodCalculator()
            paymentRequest.requiredBillingContactFields = [.name, .postalAddress]
            
            paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
            paymentController?.delegate = self
            paymentController?.present(completion: { presented in
                if presented {
                    debugPrint("✔️ Presented payment controller")
                }
                else {
                    debugPrint("❌ Failed to present payment controller")
                }
            })
        }
    }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, 
                                        didAuthorizePayment payment: PKPayment,
                                        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let errors = [Error]()
        let status = PKPaymentAuthorizationStatus.success
        
        self.paymentStatus = status
        
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    if let completionHandler = self.completionHandler {
                        completionHandler(true)
                    }
                }
                else {
                    if let completionHandler = self.completionHandler {
                        self.paymentStatus = .failure
                        completionHandler(false)
                    }
                }
            }
        }
    }
}
