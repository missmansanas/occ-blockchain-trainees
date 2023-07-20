function addition(number1, number2) {
    return (number1 + number2)
}

function substraction(number1, number2) {
    return (number1 - number2)
}

function multiply(number1, number2) {
    return (number1 * number2)
}

function division (number1, number2) {
    if (number2 === 0) {
      return "Cannot divide by zero.";
    } else {
      return number1 / number2;
    }
}

function calculator(){
    let num1 = parseFloat(prompt("First Number: "));
    let operation = prompt("Enter the operation: +, -, *, /");
    let num2 = parseFloat(prompt("Second Number: "));

    let result;

    if (operation === '+'){
        result = addition(num1, num2);
    } else if (operation === '-'){
        result = substraction(num1, num2);}

        else if (operation === '*'){
        result = multiply(num1, num2);}

        else if (operation === '/'){
        result = divition(num1, num2);

        } else {
            result = "Error, Please use a valid operator"
        } 
        
        alert('Result '+ result);
    }
        