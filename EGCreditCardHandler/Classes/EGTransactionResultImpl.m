//
//  EGTransactionResultImpl.m
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 5/1/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import "EGTransactionResultImpl.h"
#import "EGCardTransactionFactory.h"

@interface EGTransactionResultImpl ()

@property (nonatomic) NSInteger itemId;
@property (nonatomic) EGCardTransactionType type;
@property (nonatomic, copy) NSString* seatNumber;
@property (nonatomic, copy) NSString* fareClass;
@property (nonatomic, copy) NSString* frequentFlyerStatus;
@property (nonatomic, copy) NSString* currencyCode;
@property (nonatomic, copy) NSString* uniqueTransactionId;
@property (nonatomic, copy) NSDecimalNumber* amount;

@end

@implementation EGTransactionResultImpl

- (instancetype)initWithCardTransaction:(id<EGCardTransaction>)cardTransaction trackData:(NSString*)trackData finalAmount:(NSDecimalNumber*)finalAmount
{
	self = [super init];
	
	if (self) {
		self.itemId = cardTransaction.itemId;
		self.type = cardTransaction.type;
		self.seatNumber = cardTransaction.seatNumber;
		self.fareClass = cardTransaction.fareClass;
		self.frequentFlyerStatus = cardTransaction.frequentFlyerStatus;
		self.currencyCode = cardTransaction.currencyCode;
		self.uniqueTransactionId = [[NSUUID UUID] UUIDString];
		self.cardTrackData = trackData;
		self.amount = finalAmount;
	}
	
	return self;
}

@end
