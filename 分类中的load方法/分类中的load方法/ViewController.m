//
//  ViewController.m
//  分类中的load方法
//
//  Created by 赵鹏 on 2019/5/13.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 ·+load类方法会在runtime加载类、分类的时候调用。也就是说，不管+load类方法的所在类有没有真正在代码中用到，只要程序运行起来了，就会把所有的类都加载进程序的内存中，即都会调用他们的+load类方法；
 ·每个类、分类的+load类方法在程序运行的过程中只会被调用一次；
 ·一般情况下开发者不会主动去调用+load类方法，都是让系统自动进行调用；
 
 ·+load类方法的调用原理：
 1、调用顺序：对于一个原类有多个分类的情况，在程序运行以后，系统会先调用原类中的+load类方法，然后再逐个调用分类中的+load类方法；
 2、调用原理：根据分类的实现原理，在程序编译之后，分类的底层结构是struct category_t结构体，这个结构体里面存储着分类的对象方法、类方法、属性和协议信息。在程序运行的时候，Runtime会动态地将分类里面的数据合并到类信息（class对象、meta-class对象）中。在本Demo中，程序运行以后，系统会把ZPPerson类的分类ZPPerson+ZPTest和ZPPerson+ZPTest1类中的"load"和"test"类方法合并到ZPPerson类的meta-class对象中去，这样算上它自己的类方法就一共有三组"load"和"test"类方法了，这些类方法都存储在ZPPerson类的meta-class对象中的类方法数组中，根据《day05》中的《Category》Demo中所讲的原类和分类中的实例方法或者类方法的调用原则，排在前两组的应该是两个分类的类方法，最后一组应该是本类的类方法。按理来说当系统调用"load"类方法的时候，调用的应该是第一组中的"load"类方法，即最后参与编译的分类(ZPPerson+ZPTest1)中的"load"类方法，但实际上系统把每个类中的"load"类方法都调用了一遍，其原因就在于，从Runtime源码中可以看到系统会先调用原类的"load"类方法，然后再调用分类的"load"类方法。在调用原类的"load"类方法的时候，系统先获取到这个类方法的指针，然后根据这个指针再去调用原类的"load"类方法。在调用分类的"load"类方法的时候，跟调用原类的相似，也是先获取到这个类方法的指针，然后根据这个指针再去调用这个分类的load"类方法；
 3、对于一个原类有多个分类的情况，调用+load类方法和调用其他实例方法和类方法([ZPPerson test];)的区别：
 前者是通过指针的方式直接调用"load"类方法的，后者是通过Runtime消息发送的方式进行调用的。
 
 ·load类方法调用顺序的原则：
 1、对于没有任何关系的类(ZPPerson、ZPDog、ZPCat)来讲，系统会先调用先编译的类的load类方法，后调用后编译的类的load类方法；
 2、对于有父子关系的两个类(ZPPerson、ZPStudent)来讲，系统会先调用父类的load类方法，然后再调用子类的load类方法；
 3、对于有分类关系的两个类(ZPPerson、ZPPerson+ZPTest)而言，系统先调用原类的load类方法，再调用分类的load类方法；
 4、对于多个分类(ZPPerson+ZPTest、ZPPerson+ZPTest1、ZPStudent+ZPTest、ZPStudent+ZPTest1)而言，不管他们的原类是什么关系，系统都会按照编译的先后顺序调用它们的load类方法，即先调用先编译的分类的load类方法，后调用后编译的分类的load类方法。
 
 也可以把上述的原则概括如下：
 1、先调用原类的load类方法：
 ①按照编译的先后顺序进行调用（先编译，先调用）；
 ②在调用子类的load类方法之前，会先调用父类的load类方法。
 2、再调用分类的load类方法：
 按照编译的先后顺序进行调用（先编译，先调用）。
 */

#import "ViewController.h"
#import "ZPPerson.h"
#include <objc/message.h>"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /**
     ·代码运行原理：根据《day05》中的《Category》Demo，分类里面的实例方法或者类方法是在程序运行的时候合并到原类的class对象或者meat-class对象里面的。当运行下面的代码的时候，相当于"objc_msgSend([ZPPerson class], @selector(test));"，即向ZPPerson的class对象发送了一个test消息。系统会根据ZPPerson类的class对象里面的isa指针找到ZPPerson类的meat-class对象，然后在这个meat-class对象里面找到类方法存储列表，接着在这个类方法存储列表中按顺序遍历查找所需的类方法，ZPPerson+ZPTest1类是在ZPPerson类和ZPPerson+ZPTest类中最后一个参与编译的，越是往后参与编译的分类，越是优先调用它里面的方法，所以系统首先找到的是最后参与编译的ZPPerson+ZPTest1类里面的"test"类方法，然后再进行调用，整个方法的调用过程就到此为止了，看上去就像是分类里面的方法把原类里面的方法给覆盖了。如果没有找到相应的类方法的话就根据这个meat-class对象中的superclass指针找到这个类的父类的meat-class对象，再在这个meat-class对象中继续寻找，就这样一层一层地往上查找，直到找到NSObject（基类）的meat-class对象，如果在这个meat-class对象中还是没有找到的话，就根据NSObject的meat-class对象中的superclass指针找到NSObject的class对象，在这里面继续查找"test"实例方法，如果找到的话就进行调用，如果还是找不到的话就报“方法找不到”错误，至此，整个调用过程就结束了。
     ·备注：由objc_msgSend函数可以看出，ZPPerson类在调用方法的时候其实看不出来调用的是实例方法还是类方法，只是给ZPPerson的class对象发送了一个消息，所以系统按照isa指针和superclass指针逐一的进行查找，找到了就进行调用，找不到就报错。
     */
    [ZPPerson test];
}

@end
