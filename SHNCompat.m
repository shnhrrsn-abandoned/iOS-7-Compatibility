//
//  SHNCompat.m
//
//  Created by Shaun Harrison on 8/23/13.
//  Copyright (c) 2013 Shaun Harrison. All rights reserved.
//

#import "SHNCompat.h"
#import <objc/runtime.h>

#pragma mark - Run time methods

static void SHNCompatSwapSelectors(Class cls, SEL sel1, SEL sel2, BOOL areClassMethods) {
	if(!sel1 || !sel2) return;
	
	Method method1;
	Method method2;
	
	if(areClassMethods) {
		method1 = class_getClassMethod(cls, sel1);
		method2 = class_getClassMethod(cls, sel2);
	} else {
		method1 = class_getInstanceMethod(cls, sel1);
		method2 = class_getInstanceMethod(cls, sel2);
	}
	
	if(!areClassMethods && class_addMethod(cls, sel1, method_getImplementation(method2), method_getTypeEncoding(method2))) {
		class_replaceMethod(cls, sel2, method_getImplementation(method1), method_getTypeEncoding(method1));
	} else {
		method_exchangeImplementations(method1, method2);
	}
}

#pragma mark - Compatibility interfaces if compiling against iOS 6

@interface UIView (SHNCompat_iOS7)
@property(nonatomic,strong) UIColor* tintColor;
@property(nonatomic) NSInteger tintAdjustmentMode;
@end

@interface UINavigationBar (SHNCompat_iOS7)
@property(nonatomic,strong) UIColor* barTintColor;
@end

@interface UIToolbar (SHNCompat_iOS7)
@property(nonatomic,strong) UIColor* barTintColor;
@end

@interface UITabBar (SHNCompat_iOS7)
@property(nonatomic,strong) UIColor* barTintColor;
@end

@interface UISearchBar (SHNCompat_iOS7)
@property(nonatomic,strong) UIColor* barTintColor;
@end

@interface UIImage (SHNCompat_iOS7)
- (UIImage *)imageWithRenderingMode:(NSInteger)renderingMode;
@property(nonatomic, readonly) NSInteger renderingMode;
@end

static BOOL __atleast7;

#pragma mark - UIView compatibility

@implementation UIView (SHNCompat)

- (UIColor*)shnTintColor {
	if(__atleast7) {
		return self.tintColor;
	} else {
		UIColor* tintColor = objc_getAssociatedObject(self, "shnTintColor");
		
		if(tintColor != nil) {
			return tintColor;
		} else {
			return self.superview.shnTintColor;
		}
	}
}

- (void)setShnTintColor:(UIColor *)shnTintColor {
	if(__atleast7) {
		self.tintColor = shnTintColor;
	} else {
		objc_setAssociatedObject(self, "shnTintColor", shnTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		[self _shnTintColorDidChange];
	}
}



- (BOOL)_shnUsesInheritedTintColor {
	return objc_getAssociatedObject(self, "shnTintColor") == nil;
}

- (void)_shnTintColorDidChange {
	for(UIView* subview in self.subviews) {
		if([subview _shnUsesInheritedTintColor]) {
			[subview _shnTintColorDidChange];
		}
	}
	
	[self shnTintColorDidChange];
}

- (void)shnTintColorDidChange {
	
}

- (void)_shnTintColorDidChange7 {
	[self _shnTintColorDidChange7];
	[self shnTintColorDidChange];
}

- (SHNViewTintAdjustmentMode)shnTintAdjustmentMode {
	if(__atleast7) {
		return self.tintAdjustmentMode;
	} else {
		NSNumber* mode = objc_getAssociatedObject(self, "shnTintAdjustmentMode");
		
		if(mode == nil || [mode integerValue] == SHNViewTintAdjustmentModeAutomatic) {
			return self.superview.shnTintAdjustmentMode;
		} else {
			return [mode integerValue];
		}
	}
}

- (void)setShnTintAdjustmentMode:(SHNViewTintAdjustmentMode)shnTintAdjustmentMode {
	if(__atleast7) {
		self.tintAdjustmentMode = shnTintAdjustmentMode;
	} else {
		NSNumber* mode = shnTintAdjustmentMode == SHNViewTintAdjustmentModeAutomatic ? nil : @(shnTintAdjustmentMode);
		objc_setAssociatedObject(self, "shnTintAdjustmentMode", mode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		[self _shnTintColorDidChange];
	}
}

@end

#pragma mark - UINavigationBar compatibility

@implementation UINavigationBar (SHNCompat)

- (UIColor*)shnBarTintColor {
	if(__atleast7) {
		return self.barTintColor;
	} else {
		return self.tintColor;
	}
}

- (void)setShnBarTintColor:(UIColor *)shnBarTintColor {
	if(__atleast7) {
		self.barTintColor = shnBarTintColor;
	} else {
		self.tintColor = shnBarTintColor;
	}
}

@end

#pragma mark - UIToolbar compatibility

@implementation UIToolbar (SHNCompat)

- (UIColor*)shnBarTintColor {
	if(__atleast7) {
		return self.barTintColor;
	} else {
		return self.tintColor;
	}
}

- (void)setShnBarTintColor:(UIColor *)shnBarTintColor {
	if(__atleast7) {
		self.barTintColor = shnBarTintColor;
	} else {
		self.tintColor = shnBarTintColor;
	}
}

@end

#pragma mark - UIToolbar compatibility

@implementation UITabBar (SHNCompat)

- (UIColor*)shnBarTintColor {
	if(__atleast7) {
		return self.barTintColor;
	} else {
		return self.tintColor;
	}
}

- (void)setShnBarTintColor:(UIColor *)shnBarTintColor {
	if(__atleast7) {
		self.barTintColor = shnBarTintColor;
	} else {
		self.tintColor = shnBarTintColor;
	}
}

@end

#pragma mark - UISearchBar compatibility

@implementation UISearchBar (SHNCompat)

- (UIColor*)shnBarTintColor {
	if(__atleast7) {
		return self.barTintColor;
	} else {
		return self.tintColor;
	}
}

- (void)setShnBarTintColor:(UIColor *)shnBarTintColor {
	if(__atleast7) {
		self.barTintColor = shnBarTintColor;
	} else {
		self.tintColor = shnBarTintColor;
	}
}

@end

#pragma mark - UIImage compatibility

@implementation UIImage (SHNCompat)

- (UIImage*)shnImageWithRenderingMode:(SHNImageRenderingMode)renderingMode {
	if(__atleast7) {
		return [self imageWithRenderingMode:(NSInteger)renderingMode];
	} else {
		UIImage* image = [self copy];
		objc_setAssociatedObject(image, "shnRenderingMode", @(renderingMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		return image;
	}
}

- (SHNImageRenderingMode)shnRenderingMode {
	if(__atleast7) {
		return (NSInteger)self.renderingMode;
	} else {
		return [objc_getAssociatedObject(self, "shnRenderingMode") integerValue];
	}
}

- (void)shnDrawAtPoint:(CGPoint)point {
	[self drawAtPoint:point blendMode:kCGBlendModeNormal alpha:1.0f];
}

- (void)shnDrawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
	if(self.shnRenderingMode == SHNImageRenderingModeAlwaysTemplate) {
		CGSize size = self.size;
		[self drawInRect:CGRectMake(point.x, point.y, size.width, size.height) blendMode:blendMode alpha:alpha];
	} else {
		[self shnDrawAtPoint:point blendMode:blendMode alpha:alpha];
	}
}

- (void)shnDrawInRect:(CGRect)rect {
	if(self.shnRenderingMode == SHNImageRenderingModeAlwaysTemplate) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSaveGState(context);
		
		CGContextTranslateCTM(context, rect.origin.x, CGRectGetMaxY(rect));
		CGContextScaleCTM(context, 1.0f, -1.0f);
		rect.origin.x = 0.0f;
		rect.origin.y = 0.0f;

		CGContextClipToMask(context, rect, self.CGImage);
		CGContextFillRect(context, rect);

		
		CGContextRestoreGState(context);
	} else {
		[self shnDrawInRect:rect];
	}
}

- (void)shnDrawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
	if(self.shnRenderingMode == SHNImageRenderingModeAlwaysTemplate) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSaveGState(context);
		CGContextSetAlpha(context, alpha);
		CGContextSetBlendMode(context, blendMode);
		
		[self drawInRect:rect];
		
		CGContextRestoreGState(context);
	} else {
		[self shnDrawInRect:rect blendMode:blendMode alpha:alpha];
	}
}

- (UIImage*)_shnImageTintedWithColor:(UIColor*)color {
	UIImage* image = self.shnRenderingMode == SHNImageRenderingModeAlwaysTemplate ? self : [self shnImageWithRenderingMode:SHNImageRenderingModeAlwaysTemplate];
	
	UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
	[color set];
	[image drawAtPoint:CGPointZero];
	UIImage* tintedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return tintedImage;
}

@end

#pragma mark - UIImageView compatibility

@implementation UIImageView (SHNCompat)

- (UIImage*)shnImage {
	return objc_getAssociatedObject(self, "shnImage");
}

- (void)shnSetImage:(UIImage *)image {
	objc_setAssociatedObject(self, "shnImage", image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	if(image.shnRenderingMode == SHNImageRenderingModeAlwaysTemplate) {
		image = [image _shnImageTintedWithColor:self.shnTintColor];
	}
	
	[self shnSetImage:image];
}

- (UIImage*)shnHighlightedImage {
	return objc_getAssociatedObject(self, "shnHighlightedImage");
}

- (void)shnSetHighlightedImage:(UIImage *)highlightedImage {
	objc_setAssociatedObject(self, "shnHighlightedImage", highlightedImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

	if(highlightedImage.shnRenderingMode == SHNImageRenderingModeAlwaysTemplate) {
		highlightedImage = [highlightedImage _shnImageTintedWithColor:self.shnTintColor];
	}
	
	[self shnSetHighlightedImage:highlightedImage];
}

- (void)_shnTintColorDidChange {
	[super _shnTintColorDidChange];
	
	UIImage* image = self.image;
	
	if(image.shnRenderingMode == SHNImageRenderingModeAlwaysTemplate) {
		[self shnSetImage:[image _shnImageTintedWithColor:self.shnTintColor]];
	}
	
	image = self.highlightedImage;
	
	if(image.shnRenderingMode == SHNImageRenderingModeAlwaysTemplate) {
		[self shnSetHighlightedImage:[image _shnImageTintedWithColor:self.shnTintColor]];
	}
}

@end

#pragma mark - Compatibility manager

@implementation SHNCompat

+ (void)start {
	__atleast7 = [UIView instancesRespondToSelector:@selector(tintColor)];
	
	if(__atleast7) {
		SHNCompatSwapSelectors([UIView class], @selector(tintColorDidChange), @selector(_shnTintColorDidChange7), NO);
	} else {
		SHNCompatSwapSelectors([UIImage class], @selector(drawAtPoint:), @selector(shnDrawAtPoint:), NO);
		SHNCompatSwapSelectors([UIImage class], @selector(drawAtPoint:blendMode:alpha:), @selector(shnDrawAtPoint:blendMode:alpha:), NO);
		
		SHNCompatSwapSelectors([UIImage class], @selector(drawInRect:), @selector(shnDrawInRect:), NO);
		SHNCompatSwapSelectors([UIImage class], @selector(drawInRect:blendMode:alpha:), @selector(shnDrawInRect:blendMode:alpha:), NO);

		SHNCompatSwapSelectors([UIImageView class], @selector(setImage:), @selector(shnSetImage:), NO);
		SHNCompatSwapSelectors([UIImageView class], @selector(setHighlightedImage:), @selector(shnSetHighlightedImage:), NO);
		SHNCompatSwapSelectors([UIImageView class], @selector(image), @selector(shnImage), NO);
		SHNCompatSwapSelectors([UIImageView class], @selector(highlightedImage), @selector(shnHighlightedImage), NO);
	}
}

@end

