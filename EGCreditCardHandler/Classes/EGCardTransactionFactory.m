//
//  EGCardTransactionFactory.m
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import "EGCardTransactionFactory.h"
#import "EGCardTransactionImpl.h"

@implementation EGCardTransactionFactory

+ (id<EGCardTransaction>)transactionWithType:(EGCardTransactionType)type
									  amount:(NSDecimalNumber*)amount
								currencyCode:(NSString*)currencyCode
									  itemId:(NSInteger)itemId
								  seatNumber:(NSString*)seatNumber
								   fareClass:(NSString*)fareClass
						 frequentFlyerStatus:(NSString*)frequentFlyerStatus
{
	return [[EGCardTransactionImpl alloc] initWithType:type
												amount:amount
										  currencyCode:currencyCode
												itemId:itemId
											seatNumber:seatNumber
											 fareClass:fareClass
								   frequentFlyerStatus:frequentFlyerStatus];
}

@end
