#####斯坦福白胡子老头iOS课程精炼提取-----第二讲

<font color=#000000>
这节课将会跟大家讲述Swift中的<font color=#029172>Properties、实例变量相关内容以及如何去初始化它们</font>。
***
1、当你从SB中拖拽一个控件进入代码区属性的时候，你会发现这个控件后面自动加了一个"!"，以及为什么我们从一开始不需要将它赋值？如下面的代码，第二句必须要给初始化值。而第一句却不需要。
	
	@IBOutlet weak var display:UILabel!
	var judge:Bool = false
上面代码第一句，他看上去虽然不是Optional类型，但它确实是Optional。而且Optional在你使用之前就赋值了nil，其实它的形式是这样，但只不过默认都做好了就省略了后面的=nil。所以你不需要对它进行初始化，因为"!"默认已经把这个值初始化为nil。

	 @IBOutlet weak var display: UILabel! = nil
其实你也可能会疑问，把"!"改成"?"怎么办？如下：
	
	 @IBOutlet weak var display: UILabel？
会出现错误。那么"?"和"!"号具体有什么区别呢？答案是：对于实际类型而言它们没有区别，它仍然是一个Optional的值 其值在这里可能是一个UILabel类型，但是它们在用法上是不一样的，这完全是编译器帮你做好的事情。"UILabel？"是一个不确定值的变量，所以也就明白了"UILabel？"是Optional的类型，"UILabel？"所以你用这个会出现找不到UILabel里面的属性的错误。那么如何解决这个问题呢？还是用"!"解包。比如你后面想用这个label的属性，那就需要像这样操作。

	let num = display!.text
这是一件很有意思的事情。因为我第一讲中已经说到，对象初始化后，它里面的属性也必须初始化。但这样操作就没有初始化，白胡子老爷爷并没有说原因。回到代码，如果我们每次用到display的时候，都去加上"display!"感叹号，未免太麻烦。所以，我们在声明的时候就加上"!"，让它自动去解包。后面使用display的时候就不需要再去加上"display!"感叹号了。这种就叫做"unwrapped optional"，表示在创建的时候就赋值，那么将一直被赋值。
	
	@IBOutlet weak var display:UILabel!
	var num:NSInteger!
	
***
2、初始化一个数组。这两个写法是一样的，因为Swift是强类型语言，它会根据"="号后进行类型判断。初始化了一个数组，这个数组是由Double类型的数据组成。

	var arrA:Array<Double> = Array<Double>()
    var arrB = Array<Double>()
***
3、在Swift中将函数作为参数传递是很常见的事情。例如以下代码实现的闭包函数，所达到的效果是一样的。

<font color=#029172>代码一：</font>
	
	// 函数
	func doSomething(opera:(Double, Double) -> Double) {
       	opera(1.123, 1.23123)
    }
    // 等于doSomething的参数相同
    func create(double1:Double, double2:Double) -> Double 	{
        return 1.21231
    }
    // 把create作为参数传递
    doSomething(create)
    
	
<font color=#029172>代码二：</font>
	
    func doSomething(opera:(Double, Double) -> Double) {
        opera(1.123, 1.23123)
    }
    doSomething({ (double1:Double, double2:Double) -> Double in
        return double1 * double2
    })

***
4、Swift中有一个很有趣的功能。它不强制要求你给参数命名。如果不命名的参数，程序自动给参数起名为$0,$1,$2,$3...，有几个参数就到几个。
	
	// 原写法
	doSomething({ (double1:Double, double2:Double) -> Double in
        return double1 * double2
    })
	// 写法1
	doSomething({ $0 + $1 })
	// 写法2
	doSomething(){ $0 + $1 }
	
看到这里你是不是都快醉了，反正我是快醉了。天天用闭包，没想到还可以这么用。
***
5、MVC中Model、Controller、View关系链。假如你做一个音乐软件，Model里面存储1000首歌，View里面负责展示并播放给你听，Controller负责去Model里面拿一首歌曲然后给View去展示播放。	
	
	//关系链条
	a、Model和View:永远没有直接沟通
	b、Controller和View：可以通信，Controller可以直接通信View，而View需要通过协议代理通信Controller
	c、Controller和Model：Controller可以直接通信Model，但是Model不能通信Controller。但是如果Model数据库被人修改，需要通知Controller怎么办，那就需要广播室通知－－NSNotification和KVO。
	
你可能会问，View通信Controller可以使用NSNotification么，也许可以，但是最好不要这么做，因为这样违背了MVC的原则。
***
6、如果一个复杂大型的项目，我们可以使用多个MVC。因为一个MVC可以将另一个MVC当作视图的一部分，所以一个完整的MVC可以被一个稍大些的MVC当做仆从使用。我们可以一层一层地这样堆叠，就可以制作出越来越复杂的应用。例如，你写一个日历应用，它的整体上是MVC，那么这个日历里面会展示日视图，月视图等等，他们每一个也都可以使用一个小的MVC来开发，那么这就形成了堆叠。

<a href="http://mp.weixin.qq.com/s?__biz=MzI2MTQ0NzI1OA==&tempkey=a5lNSughyrq54uVJAeGbw2yZMoUnoY6%2BPtaZ4iMZ8B7eCeXSEbZG5wE2nWe1rSF3UMFebuXz7ErY%2FwR4fUBxYaug8nKSus3tnnfY5uhr%2FLsHyFCFbDUibPnNlrZDxQAcpmGtmD2Y%2F%2F0cHs1LXW59IA%3D%3D&chksm=6a5b0ad25d2c83c49299ff1420791eb5c376dc04fb33c8bfac81088baa2fdfd7e231ae3d2d7a#rd">点击关注 不会再遗漏好文章</a>
    
	