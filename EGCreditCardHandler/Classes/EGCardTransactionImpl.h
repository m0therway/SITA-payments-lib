//
//  EGCardTransactionImpl.h
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGCardTransactionFactory.h"

@interface EGCardTransactionImpl : NSObject <EGCardTransaction>

- (instancetype)initWithType:(EGCardTransactionType)type
					  amount:(NSDecimalNumber*)amount
				currencyCode:(NSString*)currencyCode
					  itemId:(NSInteger)itemId
				  seatNumber:(NSString*)seatNumber
				   fareClass:(NSString*)fareClass
		 frequentFlyerStatus:(NSString*)frequentFlyerStatus;

@end
