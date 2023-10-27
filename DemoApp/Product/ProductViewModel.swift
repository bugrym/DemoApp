//
//  ProductViewModel.swift
//  DemoApp
//
//  Created by vbugrym on 26.10.2023.
//

import Foundation
import StoreKit

@MainActor
class ProductViewModel: ObservableObject {
    
    private let productIds = ["demoAppPremium"]
    
    @Published
    private(set) var products: [Product] = []
    @Published
    private(set) var purchasedProductIDs = Set<String>()
    
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    init() {
        self.updates = observeTransactionUpdates()
    }
    
    deinit {
        self.updates?.cancel()
    }
    
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }
    
    func purchase() async throws {
        guard let product = products.first else {
            return
        }
        
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
        case .pending, .userCancelled: 
            break
        @unknown default:
            break
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
}
