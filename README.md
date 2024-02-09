# skeleton

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Test the Stripe integration & Use any CVC, postal code, and future expiration date.
   Card NUMBER	            DESCRIPTION
1) 4242424242424242	:- Succeeds and immediately processes the payment.
2) 4000002500003155	:- Requires authentication. Stripe will trigger a modal asking for the customer to authenticate.
3) 4000000000009995	:- Always fails with a decline code of insufficient_funds.

for more visit https://stripe.com/docs/testing?testing-method=card-numbers
continuously 

#FFC007