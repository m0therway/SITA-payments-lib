//
//  EGCardTransactionFactory.h
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The type of transaction being processed.
 */
typedef enum {
	EGCardTransactionTypePurchase,
	EGCardTransactionTypeRefund
} EGCardTransactionType;

//typedef enum {
//	EGCardReadTypeSwipe,
//	EGCardReadTypeNFC,
//	EGCardReadTypeEMV
//} EGCardReadType;

/**
 * An immutable object representing a single credit card transaction.
 * This may be created using EGCardTransactionFactory.
 */
@protocol EGCardTransaction <NSObject>

/**
 * Specifies whether this is a purchase or a refund.
 */
- (EGCardTransactionType)type;

/**
 * The amount of the transaction.
 */
- (NSDecimalNumber*)amount;

/**
 * The ISO code for the currency in which the amount is expressed. For instance, "USD" or "EUR".
 */
- (NSString*)currencyCode;

/**
 * An identifier for the item being sold. This will be captured in the Payment Report.
 */
- (NSInteger)itemId;

/**
 * The seat number associated with the transaction. This will be captured in the Payment Report.
 */
- (NSString*)seatNumber;

/**
 * The fare class associated with the transaction. This will be captured in the Payment Report.
 */
- (NSString*)fareClass;

/**
 * The frequent flyer status of the customer associated with the transaction.
 * This will be captured in the Payment Report.
 */
- (NSString*)frequentFlyerStatus;

@end

/**
 * A factory for creating EGCardTransaction objects.
 */
@interface EGCardTransactionFactory : NSObject

/**
 * Creates a new, immutable transaction object.
 * 
 * @param type Specifies whether this is a purchase or a refund.
 * @param amount The amount of the transaction.
 * @param currencyCode The ISO code for the currency in which the amount is expressed. For instance, "USD" or "EUR".
 * @param itemId An identifier for the item being sold. This will be captured in the Payment Report.
 * @param seatNumber The seat number associated with the transaction. This will be captured in the Payment Report.
 * @param fareClass The fare class associated with the transaction. This will be captured in the Payment Report.
 * @param frequentFlyerStatus The frequent flyer status of the customer associated with the transaction. This will be captured in the Payment Report.
 *
 * @return An object conforming to the EGCardTransaction protocol.
 */
+ (id<EGCardTransaction>)transactionWithType:(EGCardTransactionType)type
									  amount:(NSDecimalNumber*)amount
								currencyCode:(NSString*)currencyCode
									  itemId:(NSInteger)itemId
								  seatNumber:(NSString*)seatNumber
								   fareClass:(NSString*)fareClass
						 frequentFlyerStatus:(NSString*)frequentFlyerStatus;

@end
