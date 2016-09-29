###斯坦福白胡子老头ios课程精炼提取-----第四讲

***

####一、***Optional***到底是什么?

<font name = "微软雅黑">
***Optional***就是***enum***，是一个非常简单的***enum***，它是泛型的，类似于***Array***，就像你指定***Array***数组里的类型一样。下面代码中,***enum***中的***T***，就是关联值的类型。***enums***可以关联各种值，如果***Optional***不是***nil***，这就是它的类型，你就可以获取到它，这就是***enum***。举个例子，下面的例子。可以看出***x***可以是一个***enum***或者是一个***Optional String***。

```javascript
enum Optional<T> {
	case None
	case Some(T)
}
// 对应上面的例子:
// 🔽我们可以表示 x = Optional.None
let x: String? = nil
...is...
let x = Optional<String>.None
let x: String? = "Hello"
// 🔽将其赋值 x = Optional.Some 
// 关联值也就是"Hello"
let x = Optional<String>.Some("Hello")

```
可以看出，***Optional***由问号及感叹号组成。
***
####二、**解包**
紧接着，根据"一"里的代码，可以理解，解包只是***switch***与***case***在***"Some"***的情况下你可以得到的值，在***"None"***的情况下，就会抛出异常，这就是为什么你解包一个***nil***的时候会出现异常崩溃。

```javascript
switch x {
	case Some(let value): y = value
	case None: // raise an exception
}
```
***
####三、**Array**
两种创建方式

```javascript
var a = Array<String>()
...is the same is ...
var a = [String]()
}
var a = ["a", "b", "c"]
for x in a {
	print(a)
}
```
***
####四、**Dictionary**
两种创建方式

```javascript
var dic = Dictionary<String, Int>()
...is the same is ...
var dic = [String, Int]()
}

var dic = ["Stanford":1, "Cal":16]
// ranking is an Int? (would be nil)
let a = dic["nihao"]

// 枚举Dictionary
for (key, value) in dic {
	print("\(key) = \(value)")
}
```
如果通过方括号访问一个Dictionay，它会返回一个***Optional***,举个例子，我在***dic***中寻找***"nihao"***。明显就没有，那么久返回***nil***吧。这就是为什么你访问一个***Dictionary***，它会返回***Optional***。
***
####四、**Range**
新的结构体***Range***是一个包含一种合理类型的两个点，一个是起点，另一个是终点。***Range***跟***Array***或者***Optional enum***一样，是泛型的。所以它包含了一个类型。在***Array***中指定一个范围的方法是***Range***，因为***Array***是通过***Int***索引的，所以如果你想要在数组中声明***Range***，他就需要***Int***类型的。它仅仅是一个包含了***startIndex***和***endIndex***的结构体。所以***Array***的***Range***是***Int***的一个取值区间。至于***String***，有所不同，有一种特殊的类型叫做***String.index***，它是一种对***String***的索引，这个知识点有点复杂，在后面的课程中会讲到。

```javascript
let arr = ["a","b","c","d"]
// subArr1 will be ["c","d"]
let subArr1 = arr[2...3]
// subArr2 will be ["c"]
let subArr2 = arr[2..<3]

// Range is enumeratable, like Array, String, Dictionary
for i in [27...104] {
	print(i)
}
```
***
####五、**NSObject**

***NSObject***在Object-C中是所有类的基类。在***Swift***中却没有这样一个基类，然而他有一些***iOS***中的高级特性，你的***Swift***类也可以继承自***NSObject***，只为为什么，这一块知识点牵扯的东西太多，白胡子老头要在后面的课程逐步讲到。继续，在***Swift***中，我们最好让我们的类继承自***NSObject***。
***
####六、**NSNumber**
略 白胡子老爷爷建议去看文档学习这块知识
***
####七、**NSDate**
略 白胡子老爷爷建议去看文档学习这块知识
***
####八、**NSData**
可以是巨大的比特包，也可以是一个小小的比特包。不管怎样，它里面只有无类型的数据。你可以把它看成是一个点或者是一段内存，这就是iOS可以四处传递无类型数据、原始数据的原因。
***
####九、**Classes** **Structures** **Enumerations** 
在数据结构中，有三个基础快。类、结构体、枚举这三个非常相似，它们都拥有属性和方法，***Enum***本身是不能存储任何值，你可以将值存储在枚举的关联信息。枚举是可以有计算属性的。这三种数据类型都可以有函数。

```javascript
// 类
class CalculatorBrain {
}
// 结构体
struce Vertex {
}
// 枚举
enum Op {
}

// 属性和函数
func doit(argument: Type)->ReturnValue{
}
var storeProperty = <initial value>(not enum)
var computedProperty: Type {
	get {}
	set {}
}
```
结构体和类更相似，它们两个甚至都可以有初始化构造器

```javascript
init(argument1:Type,argument2:Type,_) {
}
```
它们三个之间也有不同之处，类是唯一一个拥有继承性质，这是一种确定类是什么东西的主要定义，就是它有继承性质。内省和转型都是属于继承性质，所以关于转换的内容，你不能应用到结构体上。为了更好的理解三种结构的差异，我们从***value type***(值类型)与***reference type***(引用类型)来理解，结构体和枚举的传递和存储是通过拷贝过的变量，类属于引用类型(传递的是这些对象的指针，而这些对象本身存储在堆内存中，需要记住的是，堆内存中的对象，系统会自动为我们管理(ARC)，这样一来，我们就不需要自己去开辟和释放内存了。一旦没有任何指针指向这些对象，这些对象就会被马上清理掉 注意 这不是垃圾回收机制 这是引用计数 自动引用计数 (ARC))。

***
####十、**值类型和引用类型的区别** 

```javascript
value (struct and enum)
```
对于值类型，比如结构体，当你将它传递给方法的时候，方法使用的是它的拷贝，当你将它赋值给另外一个变量的时候也是如此。比如***let x = Array<>***然后***let y = x***，这实际上是将***x***的值拷贝一份给了***y***，获取这背后是以惰性的方式拷贝的，总之，你要知道这是一份拷贝。如果你希望赋值后你可以改变它，你只需要将这个常量赋值给一个变量(***var y = x***)，之后你就可以修改它了。当你修改他＝它时，你修改的是你拷贝来的值，而不是修改之前被拷贝的那个值(修改***y*** 不会影响***x***)。因为上诉原理，当你定义一个***struct***或者一个***enum***，并且为它添加方法来修改它的状态时，你必须在方法前面加上***mutating***关键字。这样当其他人需要使用你的***enum***或***struct***的时候，它们就必须在一个变量上来调用这些***mutating***函数，而不是在一个常量上，引用类型存储在堆中。即使一个常量指针，也会导致引用计数增加，对于指向一个对象的常量指针，你同样可以用这个常量指针发送消息，来修改所指对象里面的属性，因为这个对象存储在堆里面，而你可以用一个指针来引用它，而你可以用一个指针来指引他，当你把这个对象传递给一个方法的时候，你传递的是指向这个对象的指针，所以，如果这个对象修改了这个对象，那它修改的就是存储在堆内存的那个对象了。

使用类是一件很轻松的事情，因为系统会自动帮你管理内存。
***
####十一、**override final** 

```javascript
override:重写父类的方法
final:表示这个方法不能被重写
```
***
####十二、**函数参数名** 

```javascript
// external:外部命名 调用者准备使用 放在外面
// internal:内部命名
func foo(external internal:Int) {
	let local = internal
}
func bar(){
	let result = foo(external: 123)
}
// 使用"_"
func foo(_ internal:Int) {
	let local = internal
}
func bar(){
	// 调用的时候就看不到参数名
	let result = foo(123)
}
// 使用"#"，强制内部命名被外部使用
func foo(#internal:Int) {
	let local = internal
}
func bar(){
	// 调用的时候就看不到参数名
	let result = foo(internal: 123)
}
// kc的常用写法
func foo(first:Int, second:Double) {
	let local = internal
}
func bar(){
	let result = foo(123,second:6.6)
}
func foo(first:Int,externalSecond second:Double) {
	let local = internal
}
func bar(){
	let result = foo(123, externalSecond:6.6)
}
```
***
####十三、**Properties** 

***Properties Observe***

```javascript
var someStoredProperty: Int = 42 {
	willSet { newValue is the new value }
	oldSet { oldValue is the old value }
}
override var inheritedProperty {
	willSet { newValue is the new value }
	oldSet { oldValue is the old value }
}
```
***
####十四、**Lazy Initialization 惰性实例化** 
只有***var***才可以用***lazy***初始化这个特性，因为***let***也就是类里的常量，都必须在类的初始化方法里初始化，只有***var***可以用，***lazy let***不可以。

```javascript
lazy var myProperty = self.initializeMyProperty()
```
***
####十五、**init 初始化** 
大多数情况下我们是不需要初始化的，以类来说，类里面的变量我们一般都会赋值，相当于初始化了。再者说下*** struct***，如果你没有初始化，它会默认调它系统的初始化。

```javascript
struct MyStruct {
	var x: Int = 42
	var y: String = "moltuae"
	// comes for free
	init(x: Int, y: String) 
}
```
什么是你在***init***初始化中必须要做的事情？在类中，所有***property***都必须初始化，它们都必须有值。注意 ***Optional nil***也算它有值。在***Swift***，在类中，提供两种类型的构造器来初始化，一种是***Convenience Init***，其他的都是另一种类型***Designated Initializers***。这部分内容比较多，建议看看文档，在这里就不详细叙述(ps:我没太听懂)。

```javascript
// Failable init
init?(arg1:Type1,...) {
	// might return nil in here
}
// 举个例子 这个返回的就是Optional
let image = UIImage(named:"foo")
// 这个时候我们一般会使用
if let image = UIImage(named:"foo") {
	// image was successFully created
} else {
	// couldn't create the image
}
```
***
####十六、**try-catch** 
***try-catch***在***Swift***中很少使用它，不需要了解。***Optional***让***try-catch***变得不是必须的。***try-catch***在程序发生异常时，它们会遍历调用堆栈并且查找处理此类异常的***catch***语句。这种编程做法并不是iOS开发中常用的一种方式。
***
####十七、**创建对象** 

```javascript
let x = CalculatorBrain()
let y = CompllicatedObject(arg1:42, arg2:"Hello",...)
let z = [String]()

// 其他初始化方式
let button = UIButton.buttonWithType(.System)

// 这个方法很有意思
// 传一个数组，.join函数把这个数组用","分隔开，返回字符串。
let commaSeparatedArrayElements: String = ",".join(myArray)
```
***
####十八、**AnyObject** 
主要用于兼容现有***Objective-C API***和***iOS***代码，它并不会经常使用，***AnyObject***来构建你自己的数据结构，并不建议这样做，因为***Swift***是强类型语言，它有自己的类型推倒功能。

什么是***AnyObject***？指向一个对象的指针，也就是所一个类的实例，只是你不知道它的类是什么，所以它指向一个未知类的指针

***我们到底在什么情况下会遇到它呢***？系统的一些方法返回的或者继承的事AnyObject，这是历史遗留问题。

***如何安全的转化它，而不会崩溃呢***？这有三种方式，一种是***as***，这种方式在*** destinationViewController***不存在的时候，会直接崩溃。另一种方式是***ifsslet with as?***，***as?***会返回***Optional***，当*** destinationViewController***不存在的时候，******calVC=nil***

```javascript
// 方式一:
let calVC = destinationViewController as CalculatorViewController
// 方式二:通常使用
if let calVC = destinationViewController as? CalculatorViewController {
...
}
// 方式三:
if destinationViewController is CalculatorViewController {
...(再进行as)
}

// toolbarItems返回[AnyObject]
for item in toolbarItems {
	if let toolbarItem = item as? UIBarButtonItem {
		// do something with the toolbarItem
	}
}
...or...
for toolbarItem in toolbarItems as [UIBarButtonItem] {
	// better be so, else crash
	// can't do as? here because then it might be "for toolbarItem in nil"(makes no sense)
	//do something with the toolbarItem
}
```
***
####十九、**Functions** 

***Array***

```javascript
// Array是泛型
// 把一个数组加到另一个数组里面
arr1 += arr2

// ⬇️因为返回Optional，所以不会访问到越界的Array下标
// first：返回数组第一个
first -> T?
// last
last -> T?

//Array其他有意思的方法
append(T)
insert(T, atIndex: Int)
splice(Array<T>, atIndex: Int)

removeAtIndex(Int)
removeRange(Range)
replaceRange(Range, [T])

// 数组排序 接受一个函数作为参数
// e.g: a.sort{ $0<$1 }
// 返回一个全新的拷贝的数组
sort(isOrderdBefore:(T, T)->Bool)

//数组过滤
filter(includeElement:(T)->Bool)->[T]

// 将原来Array的每一个元素映射到一个新的Array
map(transform:[T]->U) -> [U]
let stringified:[String] = [1,2,3].map{"\($0)"}

//这个函数传入当前的值和下一个Array中的元素，
//你只需要返回他们两者的组合是什么就这样你一
//直组合、组合、 组合知道最终的结果
//举个例子，你想要累加整个Array中的值，你只
//需要输入[1,2,3].reduce，然后我们以0为初始值
//即第一个参数 我的闭包作为第二个参数 将下一个
//元素($1)累加起来
reduce(initial:U, combine:(U,T)->U)->U
let num:Int=[1,2,3].reduce(0){$0+$1}

```
***String***

```javascript
StringIndex
var s="hello"
// index is a String.index to the 3rd glyph, "l"
let index=advance(s.startIndex,2)

//它会将一个字符串拼合到另外的一个字符串之中
s.splice("abc",index)  

//截取
let s = "heabcllo"
let startIndex = advance(s.startIndex,2)
let endIndex = advance(s.startIndex,6)
let subStr = s[index..<endIndex];
subStr will be "eabcl"

//取整数部分
if num = "56.25" 
if let decimalRange = num.rangeOfString("."){
	let wholeNumberPart = num[num.startIndex..<decimalRange.startIndex]
}

//删除
s.removeRange([s.startIndex..<decimalRange.startIndex])
```
***
####二十、**Type Conversion**

```javascript
let d:Double = 37.5
let f:Float = 37.5
let x = Int(d)
let xd = Double(x)
let cgf = CGFloat(d)

// 这东西好奇葩
//print ["a", "b", "c']
let a = Array("abc")
//print "abc"
let s = String(["a","b", "c"])

// 不要写 String(37.5)，因为浮点数到字符串之间转换...
// 可以这么写String(52)
let s = String(52)
let t = "\(37.5)"
``` 







