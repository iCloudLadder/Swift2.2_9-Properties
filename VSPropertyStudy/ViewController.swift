//
//  ViewController.swift
//  VSPropertyStudy
//
//  Created by cooperLink on 16/3/15.
//  Copyright © 2016年 VS. All rights reserved.
//

import UIKit

//  计算属性和属性观察器所描述的模式也可以用于全局变量和局部变量
// 全局变量是在函数、方法、闭包或任何类型之外定义的变量。局部变量是在函数、方法或闭包内部定义的变量。
var globalObservingVar: String = "This is a global var"{
    willSet{
        print("willSet > globalObservingVar newValue = \(newValue)")
    }
    didSet {
        print("didSet > globalObservingVar oldValue = \(oldValue)")
    }
}

// 全局的常量或变量都是延迟计算的 
// 全局的常量或变量不需要 标记 lazy 特性。
var globalComputedVar: String {
    get {
        return globalObservingVar
    }
    set {
        print("globalComputedVar = \(newValue)")
    }
}



class ViewController: UIViewController {
    
    /*  什么是属性(property)？
    属性将值跟特定的类、结构或枚举关联。
    
    存储属性存储常量或变量作为实例的一部分,而计算属性计算(不是存储)一个值。
    计算属性可以用于类、结构体和枚举,存储属性只能用于类和结构体。
    
    属性也可以直接作用于类型本身,这种属性称为类型属性。
    */
    
    
    // >> 存储属性
    // 存储属性就是存储在特定类或结构体的实例里的一个常量或变量
    
    struct FixedLengthRange {
        var firstValue: Int
        let length: Int
    }
    
    func testStoredProperties(){
        var rangeOfthreeItems = FixedLengthRange(firstValue: 0, length: 3)
        rangeOfthreeItems.firstValue = 6
        
        // rangeOfthreeItems.length = 5 , error: let 常量存储属性无法修改其值
        
        // 常量结构体实例
        let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
        print("rangeOfFourItems = { \(rangeOfFourItems.firstValue), \(rangeOfFourItems.length)}")
        // rangeOfFourItems.firstValue = 5, error: 常量结构体实例的，所有属性都不能更改(也就成了常量属性)，因结构体是值类型
        
        // 相对的类(class)是引用类型，常量类实例的 变量(var)属性仍可以修改
    }
    
    
    
    // >> 延迟存储属性
    /*
    延迟存储属性是指当第一次被调用的时候才会计算其初始值的属性。
    在属性声明前使用 lazy 来标示一个延迟存储 属性。
    
    注意:
    必须将延迟存储属性声明成变量(使用 var 关键字),因为属性的初始值可能在实例构造完成之后才会得到。
    而常量属性在构造过程完成之前必须要有初始值,因此无法声明成延迟属性。
    
    使用环境：
    当属性的值依赖于在实例的构造过程结束后才会知道具体值的外部因素时,
    或者当获得属性的初始值需要复杂或大量计算时,可以只在需要的时候计算它。
    
    */
    class DataImporter {
        var fileName = "data.text"
    }
    class DataManager {
        lazy var importer = DataImporter()
        var data: [String] = []
    }
    
    func testLazyProperties(){
        let manager = DataManager()
        manager.data += ["Some data"]
        manager.data.append("Some more data")
        print(manager.data)         // 到这里， manager 的 importer属性还没被创建

        print(manager.importer.fileName) // manager 的 importer属性第一次被使用，此时刚创建
        
        // ** 注意： lazy 的属性在没有初始化时就同时被多个线程访问,则无法保证该属性只会被初始化一次，也就是非线程安全
    }
    
    
    // >> 存储属性和实例变量
    /*
     Objective-C 中为类实例存储值和引用提供两种方法。对于属性来说,也可以使用实例变量作为属性值的后端存储。(既：varName = _varName)
    
    Swift 编程语言中把这些理论统一用属性来实现。
    Swift 中的属性没有对应的实例变量,属性的后端存储也无法 直接访问。
    这就避免了不同场景下访问方式的困扰,同时也将属性的定义简化成一个语句。
    一个类型中属性的全 部信息——包括命名、类型和内存管理特征——都在唯一一个地方(类型定义中)定义。
    */
    
    
    
    
    
    // >> 计算属性
    // 计算属性不直接存储值,而是提供一个 getter 和一个可 选的 setter,来间接获取和设置其他属性或变量的值
    
    struct Point {
        var x = 0.0, y = 0.0
    }
    struct Size {
        var width = 0.0, height = 0.0
    }
    
    struct Rect {
        var origin = Point()
        var size = Size()
        var center: Point { // center 是计算属性
            get {
                let centerX = (origin.x + size.width)/2
                let centerY = (origin.y + size.height)/2
                return Point(x: centerX, y: centerY)
            }
            set(newCenter) {
                origin.x = newCenter.x - size.width/2
                origin.y = newCenter.y - size.height/2
            }
            /* 当set后没有 新值的参数 时，默认使用 newValue 作为新值参数，也就是便捷setter
            set {
                origin.x = newValue.x - size.width/2
                origin.y = newValue.y - size.height/2
            }
            */
        }
    }
    
    func testComputedProperties(){
        var square = Rect(origin: Point(x: 0, y: 0), size: Size(width: 10, height: 10))
        let squareCenter = square.center
        print("init center, x = \(squareCenter.x), y = \(squareCenter.y)")
        
        square.center = Point(x: 20, y: 20)
        print("now origin, x = \(square.origin.x), y = \(square.origin.y)")
    }
    
    
    
    // >> 只读属性
    // 只有 getter 没有 setter 的计算属性就是只读计算属性。只读计算属性总是返回一个值,可以通过点运算符访 问,但不能设置新的值。
    // 必须使用 var 关键字定义计算属性,包括只读计算属性,因为它们的值不是固定的。
    // let 关键字只用来声明常 量属性,表示初始化后再也无法修改的值。
    struct Cuboid {
        var width = 0.0, height = 0.0, depth = 0.0
        var volume: Double{ // 只读计算属性
            return width * height * depth
        }
    }
    func testOnlyReadComputedProperties(){
        let cuboid = Cuboid(width: 2, height: 4, depth: 8)
        print(cuboid.volume)
    }
    
    
    
    
    // >> 属性观察器
    /*
    
        属性观察器监控和响应属性值的变化,每次属性被设置值的时候都会调用属性观察器,甚至新的值和现在的值相同的时候也不例外。
    
        可以为除了延迟存储属性之外的其他存储属性添加属性观察器,也可以通过重写属性的方式为继承的属性(包括 存储属性和计算属性)添加属性观察器
    
        不需要为非重写的计算属性添加属性观察器,因为可以通过它的 setter 直接监控和响应值的变化。
    
        • willSet 在新的值被设置之前调用,
        • didSet 在新的值被设置之后立即调用
    
    
        willSet 观察器会将新的属性值作为常量参数传入,在 willSet 的实现代码中可以为这个参数指定一个名称,如果不指定则参数仍然可用,这时使用默认名称 newValue 表示
        didSet 观察器会将旧的属性值作为参数传入,可以为该参数命名或者使用默认参数名 oldValue
    
    
        父类的属性在子类的构造器中被赋值时,它在父类中的 willSet 和 didSet 观察器会被调用。
    
    */
    
    class StepCounter {
        var totalSteps: Int = 0{
            willSet {
                print("About to set totalSteps to \(newValue)")
            }
            didSet {
                if totalSteps > oldValue{
                    print("Added \(totalSteps - oldValue) steps")
                }
                // 如果在一个属性的观察器里为它赋值,这个值会替换该观察器之前设置的值。但不会再次执行观察器
                totalSteps = 2000
            }
        }
    }
    
    func testStepCounter(){
        let stepCounter = StepCounter()
        stepCounter.totalSteps = 100
        print("> total steps = \(stepCounter.totalSteps)")
        stepCounter.totalSteps = 2180
        print(">> total steps = \(stepCounter.totalSteps)")
        stepCounter.totalSteps = 31000
        print(">> total steps = \(stepCounter.totalSteps)")

    }
    
 
    
    
    // willSet ,先调用子类重载属性的willSet，后调用父类属性的willSet
    // didSet  ,先调用父类属性的didSet，后调用子类重载属性的didSet
    
    class SuperClass {
        var firstName: String = "init value"
        /*{
            willSet{
                print("firstName newValue = \(newValue)")
            }
            didSet{
                print("firstName oldValue = \(oldValue)")
            }
        }*/
        
        var lastName: String = "init value"{
            willSet{
            print("lastName newValue = \(newValue)")
            }
            didSet{
                print("lastName oldValue = \(oldValue)")
            }
        }
        
        var otherName: String {
            get{
                print(">> get")
                return lastName
            }
            set{
                print(">> set")
                lastName = newValue
            }
        }
    }
    
    class ChildClass: SuperClass {
        override var firstName: String{
            willSet{
                print("override firstName newValue = \(newValue)")
            }
            didSet{
                print("override firstName oldValue = \(oldValue)")
            }
        }
        
        override var lastName: String{
            willSet{
                print("override lastName newValue = \(newValue)")
            }
            didSet{
                print("override lastName oldValue = \(oldValue)")
            }
        }
        
        override var otherName: String{
            willSet{
                print("override otherName newValue = \(newValue)")
            }
            didSet{
                print("override otherName oldValue = \(oldValue)")
            }
        }
        
    }
    
    func testClassObservingProperties(){
        let childClass = ChildClass()
        childClass.firstName = "--- 1"
        childClass.lastName = "--- 2"
        childClass.otherName = "--- 3"
        
        let superClass = SuperClass()
        superClass.otherName = "--- 4"
    }
    // 在子类中重载父类中的计算属性，为父类中的计算属性添加观察器后，在子类实例中为此计算属性重新赋值时，会先调用父类中的 getter 方法，之后调用顺序 willSet --> setter --> didSet
    
    // 调用 getter 是因为 didSet 需要获取 oldValue，
    // 在最前面调用是也是为了获取 oldValue， 因为在后面获取时，属性值已经改变
    
    
    
    
    
    
    
    
    
    
    // >> 类型属性
    
    /*
        实例的属性属于一个特定类型实例,每次类型实例化后都拥有自己的一套属性值,实例之间的属性相互独立。
        也可以为类型本身定义属性,不管类型有多少个实例,这些属性都只有唯一一份。这种属性就是类型属性。
        类型属性用于定义特定类型所有实例共享的数据,比如所有实例都能用的一个常量(就像 C 语言中的静态常 量),或者所有实例都能访问的一个变量(就像 C 语言中的静态变量)。
        值类型的存储型类型属性可以是变量或常量,计算型类型属性跟实例的计算属性一样只能定义成变量属性。
    
        注：
            必须给存储型类型属性指定默认值,因为类型本身无法在初始化过程中使用构造器给类 型属性赋值。
            存储型类型属性是延迟初始化的(lazily initialized),它们只有在第一次被访问的时候才会被初始化。
            即使它们被多个线程同时访问,系统也保证只会对其进行初始化一次,并且不需要对其使用 lazy 修饰符。
    
    
        语法：
            使用关键字 static 来定义类型属性。
            在为类(class)定义计算型类型属性时,可以使用关键字 class 来支持子 类对父类的实现进行重写。
    */
    
    
    struct SomeStruct {
        static var storedDTP = "some value"
        static var computedTP: String{
            get {
                return storedDTP
            }
            set {
                storedDTP = newValue
            }
        }
    }
    
    enum SomeEnum {
            static var storedDTP = "Some value"
            static var computedTP: Int {
                return 3
            }
    }
    
    class ClassTypeClass {
                static var storedTP = "Static value"
                static var computedTP: Int {
                    return 5
                }
                
                // class 修饰的类属性 可以被子类重载， static 修饰的类属性不可被重载
                class var overrideableComputedTP: String{
                        get {
                            return storedTP
                        }
                        set {
                            storedTP = newValue
                        }
                }
                // 类存储属性 不能用 class，也即是 不能被重载
                // class var overrideableStoredTP = 10  // error
    }
    
    // 获取类型属性  类型名字后跟 . 在加想要调用的类型属性名
    func getClassType(){
        print(SomeStruct.storedDTP)
        print(SomeEnum.computedTP)
        print(ClassTypeClass.overrideableComputedTP)
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testStoredProperties()
        testLazyProperties()
        testComputedProperties()
        testStepCounter()
        
        globalObservingVar = "now value"
        print(globalComputedVar)
        globalComputedVar = "The value cannot get"
        
        testClassObservingProperties()
        
        getClassType()
        
        testClassType()
    }
    
    
    
    // 类型属性的使用
    struct AudioChannel {
        static let thresholdLevel = 10 // 所有实例 最大上限值
        static var maxInputLevelForAllChannels = 0 // 所有实例， 输入的最大值
        var currentLevel: Int = 0 {
            didSet {
                if currentLevel > AudioChannel.thresholdLevel {
                    // 将新电平值设置为阀值 ，不能超过最大上限值 thresholdLevel
                    currentLevel = AudioChannel.thresholdLevel
                }
                if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                    // 存储当前电平值作为新的最大输入电平 ，所有实例中 输入的最大值
                    AudioChannel.maxInputLevelForAllChannels = currentLevel
                }
            }
        }
    }
    
    func testClassType(){
            var leftChannel = AudioChannel()
            leftChannel.currentLevel = 4
            print("leftChannel currentLevel = \(leftChannel.currentLevel)")
            print("AudioChannel maxInputLevelForAllChannels = \(AudioChannel.maxInputLevelForAllChannels)")

            
            var rightChannel = AudioChannel()
            rightChannel.currentLevel = 8
            print("rightChannel currentLevel = \(rightChannel.currentLevel)")
            print("AudioChannel maxInputLevelForAllChannels = \(AudioChannel.maxInputLevelForAllChannels)")
            
            rightChannel.currentLevel = 13
            print("rightChannel currentLevel = \(rightChannel.currentLevel)")
            print("AudioChannel maxInputLevelForAllChannels = \(AudioChannel.maxInputLevelForAllChannels)")

    }
    

    
}

