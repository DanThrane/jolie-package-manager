# Client using an External Calculator

## About this Demo

This demo will use an external calculator service.

Since the default defined in the calculator service is to connect to a localhost
service at the default port, we won't have to add anything to the
`package.json`. Thus all we had to do were to include
`calculator/calculator_external.iol` and we could use the output-port we were
given.

## Running the Demo

Since this example using an external calculator, we must first launch the
calculator service. This can be done using:

```bash
cd ../calculator
../jpm start
```

Then to run this demo:

```bash
cd ../client_external
../jpm start
```

---

Since the package manager would most likely download both the service
definition, but also the source code to run the calculator. It might be more
convinient if we could launch the calculator with something along the lines of:

```bash
jpm start calculator
```

This would still use the configuration from `package.json`. I'm thinking that
this might serve as a nice primitive for a more advanced deployment tool.

---

