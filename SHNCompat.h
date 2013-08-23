//
//  SHNCompat.h
//
//  Created by Shaun Harrison on 8/23/13.
//  Copyright (c) 2013 Shaun Harrison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHNCompat : NSObject

+ (void)start;

@end

typedef NS_ENUM(NSInteger, SHNViewTintAdjustmentMode) {
    SHNViewTintAdjustmentModeAutomatic,
    
    SHNViewTintAdjustmentModeNormal,
    SHNViewTintAdjustmentModeDimmed,
};

@interface UIView (SHNCompat)

- (void)shnTintColorDidChange;

@property(nonatomic,strong) UIColor* shnTintColor;
@property(nonatomic) SHNViewTintAdjustmentMode shnTintAdjustmentMode;
@end

@interface UINavigationBar (SHNCompat)

@property(nonatomic,strong) UIColor* shnBarTintColor UI_APPEARANCE_SELECTOR;
@end

@interface UIToolbar (SHNCompat)

@property(nonatomic,strong) UIColor* shnBarTintColor UI_APPEARANCE_SELECTOR;
@end

@interface UITabBar (SHNCompat)

@property(nonatomic,strong) UIColor* shnBarTintColor UI_APPEARANCE_SELECTOR;
@end

@interface UISearchBar (SHNCompat)

@property(nonatomic,strong) UIColor* shnBarTintColor UI_APPEARANCE_SELECTOR;
@end

typedef NS_ENUM(NSInteger, SHNImageRenderingMode) {
    SHNImageRenderingModeAutomatic,
	
    SHNImageRenderingModeAlwaysOriginal,
    SHNImageRenderingModeAlwaysTemplate,
};

@interface UIImage (SHNCompat)

- (UIImage*)shnImageWithRenderingMode:(SHNImageRenderingMode)renderingMode;

@property(nonatomic,readonly) SHNImageRenderingMode shnRenderingMode;
@end

