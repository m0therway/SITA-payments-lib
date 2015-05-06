//
//  EGTransactionResultImpl.h
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 5/1/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EGPaymentService/EGTransactionResult.h>

@protocol EGCardTransaction;

@interface EGTransactionResultImpl : NSObject <EGTransactionResult>

// this property needs to be accessible by the subclass
@property (nonatomic, copy) NSString* cardTrackData;

- (instancetype)initWithCardTransaction:(id<EGCardTransaction>)cardTransaction trackData:(NSString*)trackData finalAmount:(NSDecimalNumber*)finalAmount;

@end
