class AddSquareAccountToPayModels < ActiveRecord::Migration[7.0]
  # Scopes a Pay::Customer / PaymentMethod / Charge to a Square merchant (mirrors
  # stripe_account). Install into your app with:
  #   bin/rails pay_square:install:migrations && bin/rails db:migrate
  def change
    add_column :pay_customers, :square_account, :string
    add_column :pay_payment_methods, :square_account, :string
    add_column :pay_charges, :square_account, :string
  end
end
