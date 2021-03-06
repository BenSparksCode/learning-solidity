# Solidity Notes

## Useful Resources

- [Solidity Style Guide](https://docs.soliditylang.org/en/v0.8.3/style-guide.html)
- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- [Hardhat Docs](https://hardhat.org/getting-started)

## Educational Tutorials and Challenges

- [CryptoZombies](https://cryptozombies.io/)
- [Ethernaut](https://ethernaut.openzeppelin.com/)
- [Damn Vulnerable DeFi](https://www.damnvulnerabledefi.xyz/)
- [Capture The Ether](https://capturetheether.com/)

## Variables

### State Variables
```
uint myUint = 100;
```

### Variable Storage:

- state variables are always in storage (on the blockchain)
- function arguments are always in memory -> uses the 'memory' keyword
- local variables of struct, array or mapping type reference storage by default
- local variables of value type (i.e. neither array, nor struct nor mapping) are stored in the stack

Be explicit about memory vs storage when dealing with **structs and arrays**. 

```
Sandwich[] sandwiches;

function eatSandwich(uint _index) public {
    Sandwich mySandwich = sandwiches[_index];
    //^ WRONG!

    Sandwich storage mySandwich = sandwiches[_index];
    //^ CORRECT - gives you pointer to storage item in array
    //you can then modify that item in the array in storage

    Sandwich memory newSandwich = sandwiches[_index];
    //Will give you a new copy of that item in the storage array
    //But this copy only stored in memory
}
```

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

When passing a struct into a function as an argument, use the 'storage' keyword to pass a pointer to the struct in blockchain storage. 

### Arrays

```
uint[2] fixedArr; //Fixed array
uint[] dynamicArr; //Dynamic array
```

If an external function returns an array, it would look like this:

```
function getArray() external pure returns(uint[] memory) {
  // Instantiate a new array in memory with a length of 3
  uint[] memory values = new uint[](3);

  // Put some values to it
  values[0] = 1;
  values[1] = 2;
  values[2] = 3;

  return values;
}
```

This is because it is cheaper to create a new array with a loop in node memory and send it back to the external caller, than to use the default storage option which write data to the blockchain and costs a lot of gas.


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

- public -> Solidity creates a getter for the var automatically, callable by anyone and from any contract.
- external -> function is callable by anyone outside of the contract, not from within contract though.
- internal -> function is callable from within contract and any contracts that inherit from this contract. 
- private -> Only callable within your contract by other functions within the same contract (not inheriting ones). Private function names usually start with '_'
- view -> doesn't change or write any state
- pure -> doesn't read, modify, or write state. Only works with data passed in.
- payable -> allows function to recieve Ether. 


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


## Addresses

Accounts on Ethereum hold ETH. Each account has an address. Users with accounts have at least 1 address.

All smart contracts have an address.

Addresses are useful to map ownership of tokens/balances to users.


## Mappings

Mappings are key-value stores for storing and looking up data.

Examples:
```
// For a financial app, storing a uint that holds the user's account balance:
mapping (address => uint) public accountBalance;
// Or could be used to store / lookup usernames based on userId
mapping (uint => string) userIdToName;
```

## For Loops



## 'msg' Properties

- msg.sender -> address that called the function


## Require

Require will throw an error and stop a function from executing if its condition isn't true.

Require is useful to verify certain conditions before running operations in functions.

```
require(keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("Vitalik")));

//this will only return true and continue the function if the _name passed in was "Vitalik"
```

## Inheritance

Inheritance gives a contract access to any public functions in the contract it's inheriting from.

E.g. contract A is B {} -> A will get all B's public functions.

Helps create logic subclasses like Animal and Cat. Also helps to share common logic between many contracts.

```
contract Doge {
  function catchphrase() public returns (string memory) {
    return "So Wow CryptoDoge";
  }
}

contract BabyDoge is Doge {
  function anotherCatchphrase() public returns (string memory) {
    return "Such Moon BabyDoge";
  }
}
```

## Internal and External

- internal -> like private, but also makes function/var accessible to contracts inheriting the host contract
- external -> like public, but functions can only be called from outside the contract

## Payable

Modifier that allows a function to accept Ether as payment.

This allows all the financial innovation happening on Ethereum - you can programmatically make things happen when certain amounts of assets are received.

- msg.value -> the variable showing the amount sent
- ether -> primitive to denote the ETH asset unit in Solidity.

```
require(msg.value == 1 ether)
```

To cast an address to an address payable:

```
address payable addr2 = address(uint160(addr1))
```

To transfer money to an address payable:

```
addr2.transfer(address(this).balance)
```

## Interfaces

For defining how your contract will interact with another contract.

Only need to specify the parts of the contract you will interact with.

### Defining Interfaces

E.g. Target Contract:
```
contract LuckyNumber {
  mapping(address => uint) numbers;

  function setNum(uint _num) public {
    numbers[msg.sender] = _num;
  }

  function getNum(address _myAddress) public view returns (uint) {
    return numbers[_myAddress];
  }
}
```

Interface to use getNum in target contract:
```
contract NumberInterface {
  function getNum(address _myAddress) public view returns (uint);
}
```

### Interacting via Interfaces

Instantiate the interface by passing in the contract address as an argument.

```
address NumberAddress = 0x1234567891011
NumberInterface numContract = NumberInterface(NumberAddress)
```

## OpenZeppelin

OpenZeppelin is a library of secure and community-vetted smart contracts that you can use in your own dApps.

### Ownable

- Sets the contract owner when deployed -> owner is the address that deploys contract
- onlyOwner modifier -> modifies a function such that only the owner can call it
- contains a function to transfer ownership to a new address

### onlyOwner Modifier

The '_;' statement in a modifier tells Solidity where the rest of the modified function's code should run, in relation to the modifier's code. 

```
  modifier onlyOwner() {
    require(isOwner());
    _;
  }
```

### Function Modifiers with Args

Could have a modifier that takes args, and use it in a function.

```
modifier olderThan(uint _age, uint _userId) {
  require(age[_userId] >= _age);
  _;
}
```

then use this modifier as follows:

```
function driveCar(uint _userId) public olderThan(16, _userId) {
  // Some function logic
}
```

## Gas Optimization

### Struct Packing

Usually a uint8 won't save you gas over a uint256. Except in structs.

Struct packing tips:
 - Use smallest integer subtypes you can get away with.
 - Put same types and subtypes next to each other in code.

E.g.
```
struct A { 
    uint32 a;
    uint b;
    uint32 c;
}

// Is less efficient than

struct B { 
    uint32 a;
    uint32 b;
    uint c;
}
```

### External View Functions

'external view' functions don't cost any gas when called externally by a user - because they ony read data, and don't change anything on the blockchain.

The Web3 library only queries the Ethereum node for the data, and doesn't create a blockchain transaction.

Internally called 'view' functions will still cost gas. 

## Unix Timestamp

'now' in Solidity will return the current Unix time.

Solidity also has the following constants to convert a uint to the appropriate number of seconds:

- seconds
- minutes
- hours
- days
- weeks
- years

## Random Numbers

The best built-in way to do random numbers in Solidity is with keccak256. Oracles could be another solution, bringing externally generated random numbers.

Something like this could implement psuedo-random number generation:
```
function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
}
```


## Security

### Tips

- Examine all public and external functions (callable by anyone) and think of ways people could abuse them.
- Use SafeMath by OpenZeppelin for maths to prevent over/underflows


### Preventing Overflows and Underflows

An overflow is when a number exceeds the largest amount a variable can store. If this happens, the value will loop back to the lowest number the variable can store.

SafeMath is a library that helps prevent this.

A library can be implemented as follows, to attach functions to native data types:

```
using SafeMath for uint256;

uint256 a = 5;
uint256 b = a.add(4);
```


## Tokens

A token standard is just a smart contract with standard functions that define how to interact with that type of token. 

### ERC-20 Tokens

[ERC-20](https://ethereum.org/en/developers/docs/standards/tokens/erc-20/) is an Ethereum standard for **fungible** tokens.

Because all ERC20 tokens follow this standard, exchanges and other services can build features that are compatible with any ERC20 token.

### ERC-721 Tokens

[ERC-721](https://ethereum.org/en/developers/docs/standards/tokens/erc-20/) is an Ethereum standard for **non-fungible** tokens (NFTs).

Each NFT token has its own unique ID. NFTs are not divisible, and can only be traded as whole units.