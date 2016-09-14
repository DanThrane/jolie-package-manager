# Client using an Internal Calculator

## About this Demo

This demo will use an internal calculator.

Since the default for the calculator service is to bind its input-port locally
to port 41000, we had to change the location in the configuration. The relevant
snippet from `package.json` is:

```json
"constants": {
    "CALCULATOR": {
        "LOCATION": "local"
    }
}
```

## Running the Demo

From this directory run:

```bash
../../jpm start
```
