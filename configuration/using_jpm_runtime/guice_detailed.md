# Types of Guice Bindings

The types of bindings listed here are from Google's Guice framework [1]. Note:
Most of this is taken directly from their Wiki.

[1]: https://github.com/google/guice

## Linked Bindings

Linked bindings map a type to its implementation:

```java
bind(TransactionLog.class).to(DatabaseTransactionLog.class);
```

## Binding Annotations

Binding annotations allow you to state which type of implementation you would
like using Java's annotations.

Thus when we need to use, say a `CreditCardProcessor` we may hint that we want a
`PayPal` one using the following code:

```java
@Inject
public RealBillingService(@PayPal CreditCardProcessor processor,
                          TransactionLog transactionLog) {
    // ...
}
```

And we define how this mapping should be done:

```java
bind(CreditCardProcessor.class)
    .annotatedWith(PayPal.class)
    .to(PayPalCreditCardProcessor.class)
```

Guice also includes a `@Named` annotation. Which saves some boiler-plate (at the
cost of less type safety):

```java
@Inject
public RealBillingService(@Named("Checkout") CreditCardProcessor processor,
                          TransactionLog transactionLog) {
    // ...
}
```

Which defines the mapping like so:

```java
bind(CreditCardProcessor.class)
    .annotatedWith(Names.named("Checkout"))
    .to(CheckoutCreditCardProcessor.class);
```

## Instance Bindings

For certain types we won't need to inject a specific implementation, but rather
a specific instance (useful for example in the case of strings).

```java
bind(String.class)
    .annotatedWith(Names.named("JDBC URL"))
    .toInstance("jdbc:mysql://localhost/pizza");

bind(Integer.class)
    .annotatedWith(Names.named("login timeout seconds"))
    .toInstance(10);
```

## Provides Methods

Allows the system user to dynamically create an instance as they are needed. For
example:

```java
@Provides @PayPal
CreditCardProcessor providePayPalCreditCardProcessor(
        @Named("PayPal API key") String apiKey) {
    PayPalCreditCardProcessor processor = new PayPalCreditCardProcessor();
    processor.setApiKey(apiKey);
    return processor;
}
```

## Provider Bindings

Allows the user to move a `@Provides` method into a class, once it reaches a
certain level of complexity.

```java
public interface Provider<T> {
  T get();
}
```

Which is the bound using:

```java
bind(TransactionLog.class).toProvider(DatabaseTransactionLogProvider.class);
```

## Untargeted Bindings

Doesn't seem very relevant in a non-OOP setting.

## Just-in-Time Bindings

`@ImplementedBy`

Annotate types tell the injector what their default implementation type is. The
@ImplementedBy annotation acts like a linked binding, specifying the subtype to
use when building a type.

```java
@ImplementedBy(PayPalCreditCardProcessor.class)
public interface CreditCardProcessor {
  ChargeResult charge(String amount, CreditCard creditCard)
      throws UnreachableException;
}
```

These can be overriden as needed. This is essentially the equivalent of:

```java
bind(CreditCardProcessor.class).to(PayPalCreditCardProcessor.class);
```

Similarly we can point to a default provider with `@ProvidedBy`.