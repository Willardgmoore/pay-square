# Usage

```ruby
# Scope the customer to a merchant
@user.set_payment_processor :square, square_account: "MLXXXXXXXXXXXX"

# Card on file (source_id is a nonce from Square's Web Payments SDK)
@user.payment_processor.add_payment_method("cnon:...", default: true)

# Charge (integer minor units), optional application fee + idempotency key
charge = @user.payment_processor.charge(10_00, application_fee_amount: 1_00, idempotency_key: "order-42")
charge.processor_id     # Square payment id
charge.square_order_id

# Refund (async; amount_refunded syncs from Square)
charge.refund!(5_00)
```

Because `square_account` is part of the customer lookup key, one user transacting with two different
Square merchants gets two isolated `Pay::Customer` records.

Square has no server-side SCA step (3-D Secure is client-side in the Web Payments SDK), so
`Pay::Payment` / `has_incomplete_payment?` do not apply — a charge either succeeds or raises
`Pay::Square::Error`.
