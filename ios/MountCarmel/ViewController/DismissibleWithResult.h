//
//  DismissibleWithResult.h
//  MountCarmel
//
//  Created by Jatin Nagar on 14/03/26.
//  Copyright © 2026 Mount Carmel Schools. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DismissibleWithResult <NSObject>
@property (nonatomic, copy) void (^onDismissWithResult)(BOOL success);
@end
