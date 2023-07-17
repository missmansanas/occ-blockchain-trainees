function addition (number1, number2) {
    return number1 + number2;
}

//let result = addition (2,5);
//console.log(result);

function subtraction (sub1, sub2) {
    return sub1 - sub2;
}

//result = subtraction (8,5);
//console.log(result);

function multiply (number1, number2) {
    return number1 * number2;
}


function division (number1, number2){
    if (number2 == 0) {
        return "Cannot divide by zero.";
    }
    else {
        return number1 / number2;
    }
    
}

//let result = division (16, 4);
//console.log(result);

function calculator () {
    let num1 = parseFloat(prompt("First number:"));
    let operation = prompt("Enter the operation: +, -, *, /");
    let num2 = parseFloat(prompt("Second number:"));

    let result;

    if (operation == "+") {
        result = addition(num1, num2) ;
    }
    else if (operation == "-") {
        result = subtraction (num1, num2);
    }
    else if (operation == "*") {
        result = multiply (num1, num2);
    }
    else if (operation == "/") {
        result = division (num1, num2);
    }
    else {
        result = "Error. Please choose a valid operator.";
    }

    console.log("Result: " + result);
}