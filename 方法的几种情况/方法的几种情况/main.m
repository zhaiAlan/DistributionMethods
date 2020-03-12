//
//  main.m
//  方法的几种情况
//
//  Created by Alan on 3/12/20.
//  Copyright © 2020 zhaixingzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZPerson.h"
#import "XZTeacher.h"
#import <objc/message.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        XZTeacher *t = [XZTeacher new];
        [t sayCode];
        // 方法调用底层编译
        // 方法的本质: 消息 : 消息接受者 消息编号 ....参数 (消息体)
        objc_msgSend(t, sel_registerName("sayCode"));
        
        // 类方法编译底层
        //        id cls = [XZTeacher class];
        //        void *pointA = &cls;
        //        [(__bridge id)pointA sayNB];
        objc_msgSend(objc_getClass("XZTeacher"), sel_registerName("sayNB"));
        
        /***
         sel_registerName
         @selector
         这两种方式是一样的
         */
        
        // 向父类发消息(对象方法)
        struct objc_super xzSuper;
        xzSuper.receiver = t;
        xzSuper.super_class = [XZPerson class];
        objc_msgSendSuper(&xzSuper, @selector(sayHello));
        
        //向父类发消息(类方法)
        struct objc_super myClassSuper;
        myClassSuper.receiver = [t class];
        myClassSuper.super_class = class_getSuperclass(object_getClass([t class]));// 父类的元类
//        这里需要注意的是，如果这里直接使用元类，而不是父类的元类，这里也能够正常调用，这个其实就是继承链，自己元类没找到，会找自己父类的元类的方法，这个后续进行详细讲解
        objc_msgSendSuper(&myClassSuper, sel_registerName("sayNB"));
         
    }
    return 0;
}
