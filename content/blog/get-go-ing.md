{
    "date": "2015-02-02",
    "description": "My notes to the official golang tour.",
    "slug": "get-go-ing",
    "tags": "go, golang, google",
    "title": "Get Go-ing!"
}

This post is a [pandoc](http://johnmacfarlane.net/pandoc/) converted
version of my [get-go-ing](https://github.com/klingtnet/get-go-ing)
github repo. It contains my example solutions and notes to the official
[golang tour](https://tour.golang.org/welcome/1).

Get Go'ing
==========

What?
-----

Playground for my [first steps in Go](https://tour.golang.org/list).

[Basics](https://tour.golang.org/basics/1)
------------------------------------------

-   Go programs are made out of **packages**
-   the `main` method must be in the **main** package
-   inside of the **import** statement are the packages specified that
    should be imported
    -   the last element of the *import path* is the package name,
        by convention. `math/rand` imports the files from `math` that
        begin with `package rand`
-   in Go, a name is exported if it begins with a capital letter, e.g.
    `math.Pi`

### [Functions](https://tour.golang.org/basics/4)

-   function definitions start with `func` followed by the function
    name, the parameter list and the return value
    -   as opposed to C, the parameter name comes before the type, e.g.
        `x int`
    -   [here
        is](https://golang.org/doc/articles/gos_declaration_syntax.html)
        why they choosed this syntax
    -   if two or more consecutive parameters share the same type, you
        can omit it from all but the last
    -   a function can return *any* number of values (like tuples
        in python)
-   **strings** are enquoted by doublequotes `"`

```go
func add(a, b int) int {
    return a+b
}
```

### [Variables & Types](https://tour.golang.org/basics/8)

-   the **var** statement declares a list of variables with the type
    last
    -   it is allowed on *function* and *package* level (global)
    -   examples:
        -   `var a, b bool`
        -   initalizers can be used like this:
            -   `var a, b, c = true, false, "hej!"`
            -   note that the type can be omitted if the initializer is
                present
            -   each variable from the initializer list can have a
                different type
    -   var statements can be factored into blocks, similar to the
        import statement, see [basictypes.go](./src/basictypes.go) for
        an example
    -   variables declared without an explicit initial value will be
        instantiated with their specific [zero
        value](https://tour.golang.org/basics/12)
-   inside a function the **short assignment** statement can be used:
    `a := 100`
-   **type conversions** can be done with `T(..)`, where `T` is the type
    and inside of the parantheses is the value to convert, e.g.
    `float64(128)`

#### [Function Values](https://tour.golang.org/moretypes/20)

-   functions can also be assigned as variable values:

```go
square := func(x int) int {
    return x*x
}
```

#### [Closures](https://tour.golang.org/moretypes/21)

-   a closure is a function value that references variables from outside
    its body

```go
func adder() func(int) int {
    sum := 0
    return func(x int) int {
        sum += x
        return sum
    }
}
```

-   the inner function can access the `sum` variable from the enclosing
    function, even after the outer function has returned

### [Constants](https://tour.golang.org/basics/15)

-   declared using the `const` keyword
-   **can't** be declared using the short assigment statement `:=`
-   constants can be character, string boolean or numeric values
-   numeric-constants are [*high-precision*
    values](https://tour.golang.org/basics/16)

### [Loops](https://tour.golang.org/flowcontrol/1)

-   go has only one looping construct, the `for` loop
-   to emulate a `while` loop leave the *pre* and *post* statements
    empty: `for ; x < y; {}`, you can even omit the *semicolon*:
    `for x < y {}`
-   omit the loop conditions and you get an infinite loop: `for {}`

```go
for i := 0; i < 10; i++ {
    sum += i
}
```

### [Conditions](https://tour.golang.org/flowcontrol/5)

-   C-like but without the parentheses:

```go
if x < y {
    x++
} else {
    y++
}
```

-   you can write a pre-statement before the if-statement
-   variables declared in this pre-statement are only visible inside the
    scope of the if statement

```go
if x := 10; x == 10 {
    fmt.Println("It's only an example.")
}
```

-   **switch-case** statements break automatically, unless you specfiy a
    *falltrough* statement (`default` case)
-   the *evaluation order* is from *top to bottom*
-   a `switch` without condition is the same as `switch true` and can be
    used for long if-else chains:

```go
switch {
case t.Hour() < 12:
    fmt.Println("Good morning!")
case t.Hour() < 17:
    fmt.Println("Good afternoon.")
default:
    fmt.Println("Good evening.")
}
```

### [Pointers](https://tour.golang.org/moretypes/1)

-   **pointer declaration** is C-like: `*T`, where `T` is the type of a
    value the pointer refers to
-   **dereferencing** the `&` generates an pointer of the value it
    refers to
-   there is no **pointer arithmetic** in Go

```go
var p *int
i := 42
p = &i
fmt.Println(*p) // prints 42
```

-   example use cases:
    -   avoid copying large structs to a function by passing a pointer
        to the struct to the function
        -   as the [Go FAQ](http://golang.org/doc/faq#pass_by_value)
            says, it's **not**
            [call-by-reference](http://en.wikipedia.org/wiki/Evaluation_strategy#Call_by_reference)
            because *the pointer is copied*, as well as every other
            argument which is passed to the function
    -   in-place modification, say you want to modify elements of a
        struct inside your function without returning it. I'm sure there
        is a valid use case for this, but I would consider it *bad
        practice* in most cases.

Structured Data
---------------

### [Structs](https://tour.golang.org/moretypes/2)

-   `struct literals` denotes a newly allocated struct
-   you can list a subset using the `Name:` syntax: `Vertex{X: 3}`
-   the indirection through struct pointers is
    [transparent](https://tour.golang.org/moretypes/4)

```go
type Vertex struct {
    X int
    Y int
}

// instantiation
v := Vertex{1, 2}
v.X = 4
```

### [Arrays](https://tour.golang.org/moretypes/6)

-   an array of `n` elements with type `T` is declared like this
    `[n]T`, e.g. `[100]rune`
-   arrays **can't** be resized
-   Go has an array slice syntax similar to pythons list slices:

```go
p := []int{2, 3, 5, 7, 11, 13}
fmt.Println(p[1:5])
```

-   `make([]T, l, c)` creates a slice with **initial length** `l`
    and (optional) **capicity** `c`
-   `len(s)` gives the *length* and `cap(s)` the *capacity* of slice `s`
-   a `nil` slice ([FP](http://en.wikipedia.org/wiki/Cons)) has length
    and capacity `0`
-   a slice can be appended with `append(s []T, vs ...T) []T`, where the
    first argument is a slice of type `T` and the following parameters
    are `T` values
-   looping over a slice:

```go
x = []int {2, 4, 8}
for i, v := range x {
    // i = index
    // v = value of x[i]
}
```

-   you can skip a loop variable when you assign `_` to it, like in
    Python: `for _, v := range x {}`

### [Maps](https://tour.golang.org/moretypes/15)

-   map declaration looks like this: `map[T_key]T_value`, e.g.
    `map[string]uint64`
-   maps have to be created with `make(map_declaration)` before using
    them
-   you can use **map literals** to initalize a map like this:

```go
var m2 = map[string]uint64{
    "foo": 42,
    "bar": 314,
}
```

-   there **must** be a trailing comma behind the last value!
-   insert `m[key] = elem`
-   get `elem = m[key]`
-   `delete(m, key)`
-   check if a key is present: `elem, ok = m[key]`, where `ok` is `true`
    if `key` is present in map `m`, otherwise `ok` is false and the
    `elem` is the zero value of its type

### [Methods](https://tour.golang.org/methods/1)

-   there is **no class** construct in Go
-   **but**, you can *define methods on* \[struct\] *types*, which is
    pratically the same (see [OOP with
    Ansi-C (pdf)](http://www.cs.rit.edu/~ats/books/ooc.pdf)) apart from
    the access modifiers
-   the declaration looks like that from a function with an additional
    **Method Receiver** between the `func` keyword and the *function
    name*
-   you can call the method like you can access struct elements:
    `foo.F()`

```go
type Vertex struct {
    X, Y float64
}

// func MethodReceiver MethodName(Params) ReturnValue
func (v Vertex) Abs() float64 {
    return math.Sqrt(v.X*v.X + v.Y*v.Y)
}
```

-   you can declare method on **any type from your package**, but not on
    others

#### Methods with [Pointer Receiver](https://tour.golang.org/methods/3)

-   two main reasons for using pointer receivers:
    -   **call-by-reference**, as default the method gets a copy of the
        struct (call-by-value)
    -   **modifying** the method receiver **in-place**. You should now
        why you want to do this, because it's the explicit usage of
        [side
        effects](http://en.wikipedia.org/wiki/Side_effect_%28computer_science%29)
-   you *can't* define the same method name for pointer and value type,
    see the example below

[./src/method\_receiver.go](./src/method_receiver.go)

```go
type Decimal struct {
    X float64
}

func (v Decimal) Double() float64 {
    return 2 * v.X
}

func (v *Decimal) DoublePR() {
    v.X = 2 * v.X
}

...
v := Decimal{3.14}
// call-by-value
fmt.Println(v, v.Double())
// use the pointer Receiver
v.DoublePR()
// DoublePR() has mutated v in-place
fmt.Println(v)
```

prints out:

    {3.14} 6.28
    {6.28}

### [Interfaces](https://tour.golang.org/methods/4)

-   an **interface type** is defined by a set of methods
-   a **type** implements an interface by **implementing its methods**
-   interfaces are **satisfied implicitly**. There is no explicit
    **implements** keyword (like in Java), therefore an interface is
    satisfied if the type implements its methods.
-   the equivalent of Java's `toString()` method is the `String()`
    method from the `Stringer` interface:

```go
type Stringer interface {
    String() string
}
```

### [Errors](https://tour.golang.org/methods/8) (Exceptions in Go)

-   `errors` is a built-in interface (similar to `Stringer`)
-   error checking is done by validating if an error value is `nil`
    (Go's null type):

```go
i, err := strconv.Atoi("42")
if err != nil {
    fmt.Printf("couldn't convert number: %v\n", err)
}
```

### [Web Servers](https://tour.golang.org/methods/13)

-   the [http package](http://golang.org/pkg/net/http/) serves HTTP
    requests using any value that implements `http.Handler`
-   those values have to implement
    `ServeHTTP(w http.ResponseWriter, r *http.Request)`
-   [http Handler](src/exercise-http-handlers.go) example

```go
func (s Struct) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    fmt.Fprint(w, fmt.Sprintf("%s%s %s\n", s.Greeting, s.Punct, s.Who))
}
```

Concurrency mechanisms
----------------------

### [Goroutines](https://tour.golang.org/concurrency/1)

-   a goroutine is a **lightweight thread**
-   the name is wordplay of
    [coroutines](http://en.wikipedia.org/wiki/Coroutine)
-   goroutines run in the same address space, so they have access to the
    shared memory → need of synchronization/locks
-   a goroutine is started with `go f()`, where `f` is an arbitrary
    function
    -   f's arguments will be evaluated in the current goroutine
    -   f will be executed in the new goroutine

### [Channels](https://tour.golang.org/concurrency/2)

-   a channel is a **types pipe** (like pipes from the shell)
-   a channel must be created before use:
    `ch := make(chan type, bufferlen)`. The `bufferlen` parameter
    is optional.
-   you can send and receive values from a channel using the `<-`
    operator:
    -   send `ch <- v`
    -   receive `v := <-ch`
-   send and receive on channels is **blocking** (until the other side
    is ready) by default
-   a buffered channel blocks only when the buffer is full
-   channels **can** be **closed** to indicate that no more values will
    be send
-   **only senders** should close channels!
-   you can check if the second return value of a receive is `false`,
    then the channel was closed: `v, ok := <-ch`

Loops until the channel was closed

```go
c := make(chan type)
//...
for v := range c {
    // ...
}
```

-   the `select` statement is like `switch-case` for channels
-   if mutliple channels are ready at once, a random channel is chosen
-   the `default` case is run if no other channel is ready (can be used
    for non-blocking send/receive)

```go
select {
case c <- x:
    x, y = y, x+y
case <-quit:
    fmt.Println("quit")
    return
}
```

### Miscellanous

-   the `defer` statement defers the execution of a function until the
    surrounding function returns
-   deferred function calls are pushed on a stack and are executed in
    **LIFO** order
-   [more on defer](http://blog.golang.org/defer-panic-and-recover)

Tips
----

-   to build & run a Go file in one step use `go run file.go`
-   Go files can be formatted automatically using the `gofmt` tool. On
    default the formatted code is written to `stdout`, to overwrite the
    source file use `gofmt -w file.go`.
-   the execution environment of a compiled program is deterministic,
    thus a *random generator* for example has to be seeded, otherwise it
    will deliver the same number on every run of the program

Further Reading
---------------

-   [go-koans](https://github.com/cdarwin/go-koans) lets you learn Go by
    fixing test cases. Sounds boring but instead it's quite fun to fix
    it!

