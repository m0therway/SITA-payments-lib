//
//  EGCardTransactionImpl.m
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import "EGCardTransactionImpl.h"

@interface EGCardTransactionImpl ()

@property(nonatomic) EGCardTransactionType type;
@property(nonatomic, copy) NSDecimalNumber* amount;
@property(nonatomic, copy) NSString* currencyCode;
@property(nonatomic) NSInteger itemId;
@property(nonatomic, copy) NSString* seatNumber;
@property(nonatomic, copy) NSString* fareClass;
@property(nonatomic, copy) NSString* frequentFlyerStatus;

@end

@implementation EGCardTransactionImpl

- (instancetype)initWithType:(EGCardTransactionType)type
					  amount:(NSDecimalNumber*)amount
				currencyCode:(NSString*)currencyCode
					  itemId:(NSInteger)itemId
				  seatNumber:(NSString*)seatNumber
				   fareClass:(NSString*)fareClass
		 frequentFlyerStatus:(NSString*)frequentFlyerStatus
{
	self = [super init];
	
	if (self) {
		self.type = type;
		self.amount = amount;
		self.currencyCode = currencyCode;
		self.itemId = itemId;
		self.seatNumber = seatNumber;
		self.fareClass = fareClass;
		self.frequentFlyerStatus = frequentFlyerStatus;
	}
	
	return self;
}

@end
