//
//  UIBarButtonItem+CustomBackButton.m
//  Kidney
//
//  Created by YongFu on 2/29/16.
//  Copyright © 2016 Fu Yong. All rights reserved.
//

#import "UINavigationItem+CustomBackButton.h"
#import <objc/runtime.h>

@implementation UINavigationItem (CustomBackButton)

+(void)load{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        // 1.设置导航栏背景
        UINavigationBar *navBar = [UINavigationBar appearance];
        [navBar setTranslucent:NO];
        [navBar setBackIndicatorImage:[UIImage imageNamed:@"back"]];
        [navBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
        [navBar setBarTintColor:[UIColor yellowColor]];
        [navBar setTintColor:[UIColor whiteColor]];
        
        // 2.设置导航栏文字属性
        NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
        [barAttrs setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [barAttrs setObject:[UIFont boldSystemFontOfSize:18] forKey:NSFontAttributeName];
        [navBar setTitleTextAttributes:barAttrs];
        
        // 3.按钮
        UIBarButtonItem *item = [UIBarButtonItem appearance];
        
        NSMutableDictionary *itemAttrs = [NSMutableDictionary new];
        [itemAttrs setObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
        [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
        [item setTitleTextAttributes:itemAttrs forState:UIControlStateHighlighted];
        [item setTitleTextAttributes:itemAttrs forState:UIControlStateDisabled];
        
        UIToolbar *toolBar = [UIToolbar appearance];
        //        [toolBar setTranslucent:NO];
        [toolBar setTintColor:[UIColor yellowColor]];
        

        Method originalMethodImp = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method destMethodImp = class_getInstanceMethod(self, @selector(myCustomBackButton_backBarbuttonItem));
        method_exchangeImplementations(originalMethodImp, destMethodImp);
    });
    
}

static char kCustomBackButtonKey = 'a';


-(UIBarButtonItem *)myCustomBackButton_backBarbuttonItem{
    
    UIBarButtonItem *item = [self myCustomBackButton_backBarbuttonItem];
    
    if (item) {
        
        return item;
        
    }
    
    item = objc_getAssociatedObject(self, &kCustomBackButtonKey);
    
    if (!item) {
        
        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:NULL];
        
        objc_setAssociatedObject(self, &kCustomBackButtonKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    return item;
    
}

- (void)dealloc {
    
    objc_removeAssociatedObjects(self);
    
}

@end
