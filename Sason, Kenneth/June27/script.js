function add(num1, num2) {
  return num1 + num2;
}
function subtract(num1, num2) {
  return num1 - num2;
}
function multiply(num1, num2) {
  return num1 * num2;
}
function divide(num1, num2) {
  return num1 / num2;
}
function calculator() {
  let num1 = parseFloat(prompt("First number:"));
  let operation = prompt("Enter the operation +,-,*,/");
  let num2 = parseFloat(prompt("First number:"));
  let result;
  if (operation === "+") {
    result = add(num1, num2);
  } else if (operation === "-") {
    result = subtract(num1, num2);
  } else if (operation === "*") {
    result = multiply(num1, num2);
  } else if (operation === "/") {
    result = divide(num1, num2);
  } else {
    result = "error!!!";
  }
  alert("Result: " + result);
}
calculator();
