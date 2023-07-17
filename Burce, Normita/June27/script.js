/*
function addition (number1, number2) {
    return number1 + number2
}

let result = addition(1,1);
console.log(result);*/

/*function subtraction (sub1, sub2) {
    return sub1 - sub2
}

/*let result = subtraction (8,5);
console.log(result);*/

/*function multiply (number1, number2) {
    return (number1 * number2)
}

/*let result = multiply (5,10);
console.log("Result: " + result);*/

/*function division (number1, number2) {
    if(number2 == 0) {
        return "cannot divide by zero";
    }
    else {
        return number1 / number2 
    }
}
/*result = division (16,0);
console.log (result);*/

function calculator () {
    let num1 = parseFloat(prompt("First number:"));
    let operation = prompt("Enter the operation: +, -, *, /");
    let num2 = parseFloat(prompt("Second number"));

    let result;

    if (operation === '+') {
        result = addition(num1, num2);
    } else if (operation === '-') {
        result = subtraction(num1, num2);
    } else if (operation === '*') {
        result = multiplication(num1,num2)
    } else if (operation === '/') {
        result = division(num1, num2);
    } else {
        result = "Error. Please choose a valid operator."
    }

    alert('Result: ' + result);
}


