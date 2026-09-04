module Pay
  module Square
    # Pay's core set/add_payment_processor dedup key is hardcoded and does not know about
    # square_account. We prepend to include it for the :square processor so one owner
    # transacting with two Square merchants gets two isolated Pay::Customers (the same
    # guarantee stripe_account provides via #1198). Everything else delegates to super.
    module Attributes
      def set_payment_processor(processor_name, square_account: nil, **options)
        return super(processor_name, **options) unless processor_name.to_sym == :square

        with_lock do
          pay_customers.update_all(default: false)
          pay_customer = pay_customers.active.where(
            Pay::Customer.inheritance_column => "Pay::Square::Customer",
            :processor => "square",
            :square_account => square_account
          ).first_or_initialize
          pay_customer.update!(options.merge(default: true))
        end

        reload_payment_processor
      end

      def add_payment_processor(processor_name, square_account: nil, **options)
        return super(processor_name, **options) unless processor_name.to_sym == :square

        pay_customer = pay_customers.active.where(
          Pay::Customer.inheritance_column => "Pay::Square::Customer",
          :processor => "square",
          :square_account => square_account
        ).first_or_initialize
        pay_customer.update!(options)
        pay_customer
      end
    end
  end
end

Pay::Attributes::CustomerExtension.prepend(Pay::Square::Attributes)
