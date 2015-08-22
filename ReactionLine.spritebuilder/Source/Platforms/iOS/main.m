//
//  main.m
//  Example
//
//  Created by Viktor on 8/12/13.
//  Copyright Apportable 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    @autoreleasepool {
        
        @try {
            return UIApplicationMain(argc, argv, nil, @"AppController");
        }
        @catch (NSException *exception) {
            NSLog(@"%@",[exception callStackSymbols]);
            return 1;
        }
        int retVal = UIApplicationMain(argc, argv, nil, @"AppController");
        return retVal;
    }
}
