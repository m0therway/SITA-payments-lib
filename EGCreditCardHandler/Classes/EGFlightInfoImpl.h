//
//  EGFlightInfoImpl.h
//  EGCreditCardHandler
//
//  Created by Nate Petersen on 4/14/15.
//  Copyright (c) 2015 eGate Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGFlightInfoFactory.h"

@interface EGFlightInfoImpl : NSObject <EGFlightInfo>

- (instancetype)initWithCompanyId:(NSInteger)companyId
						   crewId:(NSInteger)crewId
						 deviceId:(NSString*)deviceId
					departureTime:(NSDate*)departureTime
					 flightNumber:(NSString*)flightNumber
		   originatingAirportCode:(NSString*)originatingAirportCode
		   destinationAirportCode:(NSString*)destinationAirportCode;

@end
