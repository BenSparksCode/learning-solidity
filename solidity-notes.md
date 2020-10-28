# Solidity Notes

## Variables

### State Variables
```
uint myUint = 100;
```

### Variable Storage:

- state variables are always in storage (on the blockchain)
- function arguments are always in memory
- local variables of struct, array or mapping type reference storage by default
- local variables of value type (i.e. neither array, nor struct nor mapping) are stored in the stack


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

### Return Values

Function declaration explicitly contains the type of the return value.

```
function sayHello() public returns (string memory) {
    return "Hello";
}

function _multi(uint a, uint b) private pure returns (uint) {
    return a * b;
}
```

- memory -> store value in memory temporarily, not written to blockchain.

### Function Modifiers

- public -> Solidity creates a getter for the var automatically, callable by anyone
- private -> Only callable within your contract by other functions. Private function names usually start with '_'
- view -> doesn't change or write any state
- pure -> doesn't read, modify, or write state. Only works with data passed in.


## Keccak256

Keccak256 is a hash fucntion built into Ethereum, and a version of SHA3.

A hash function maps some input into a 256-bit hexidecimal number. Changing the input will change the hash (output).

Keccak256 expects a single parameter of type 'bytes'.

## Typecasting

```
uint a = 5
uint8 b = 2

uint8 c = a * b //throws an error because returns uint, not uint8

uint8 d = uint8(a) * b //works
```


## Events

For communicating when things are triggered/happening in your contract, to external listeners (e.g. frontends).

```
// declare the event
event IntegersAdded(uint x, uint y, uint result);

function add(uint _x, uint _y) public returns (uint) {
  uint result = _x + _y;
  // fire an event to let the app know the function was called:
  emit IntegersAdded(_x, _y, result);
  return result;
}
```
