//
//  STAPIManager.h
//  Stormzy
//
//  Created by Mesfin Bekele Mekonnen on 4/12/16.
//  Copyright © 2016 Mesfin Bekele Mekonnen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAPIManager : NSObject

+ (void)getJSONFromAPI:(void(^)(NSDictionary *dict))completion;

@end
