## Variables

### State Variables
```
uint myUint = 100;
```

Stores permenantly to the blockchain

### Keywords
- public -> Solidity creates a getter for the var automatically, callable by anyone
- private -> Only callable within your contract by other functions. Private function names usually start with '_'


## Math Operations

### Built-in Maths

```
x + y
x - y
x * y
x / y
x % y //mod
x ** y //exponent
```


## Data Types

### Basic

// Full in

### Structs

Complex data types that can contain multiple properties.

```
struct Person {
    uint age;
    string name;
}
```

### Arrays

```
uint[2] fixedArr; //Fixed array
uint[] dynamicArr; //Dynamic array
```


## Functions

```
function createPerson(
    string memory _name,
    uint _age
    ) public {


}

//args, memory keyword for reference var types (arrays, strings, structs, etc)
//publically callable
```