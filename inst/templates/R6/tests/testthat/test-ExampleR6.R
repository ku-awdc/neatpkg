## Run check_R6_kuawdc conditionally on neatpkg being available:
if(require("neatpkg")){
  expect_true(check_R6_kuawdc(ExampleR6))
}
