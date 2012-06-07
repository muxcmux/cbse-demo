class Transaction < ActiveRecord::Base
  
  OVERDRAFT_LIMIT = BigDecimal.new 500
  OVERDRAFT_FIXED_COST = BigDecimal.new 10
  OVERDRAFT_INTEREST = BigDecimal.new '0.02'
  
  belongs_to :account
  attr_accessible :amount, :transaction_type, :account_id, :initiator, :overdraft_cost
  
  validates :amount, :numericality => true
  validates :transaction_type, :inclusion => { :in => %w(deposit withdrawal),
    :message => "%{value} is not a valid transaction type" }
  
  before_save :transaction_possible?, :correct_amount, :set_overdraft_cost
  after_save :update_account_balance, :save_balance_state
  
  def correct_amount
    if self.transaction_type == 'withdrawal'
      self.amount = -self.amount.abs
    elsif self.transaction_type == 'deposit'
      self.amount.abs
    end
  end
  
  def transaction_possible?
    return true if self.transaction_type == 'deposit'
    if self.amount.abs + calculate_overdraft_cost > (self.account.balance + OVERDRAFT_LIMIT)
      errors[:base] << "Transaction exceeds overdraft limit."
      return false
    end
    return true
  end
  
  def update_account_balance
    self.account.balance -= calculate_overdraft_cost if is_overdraft?
    self.account.balance += self.amount
    self.account.save
  end
  
  def save_balance_state
    self.update_column :balance, self.account.balance
  end
  
  def is_overdraft?
    return false if self.transaction_type == 'deposit'
    return true if (self.account.balance - self.amount.abs) < 0
    return false
  end
  
  def calculate_overdraft_cost
    if is_overdraft?
      if self.account.balance < 0
        interest_base = self.amount.abs
      else
        interest_base = self.account.balance.abs - self.amount.abs
      end
      cost = OVERDRAFT_FIXED_COST + (interest_base.abs * OVERDRAFT_INTEREST)
    else
      cost = 0
    end
    return cost
  end
  
  def set_overdraft_cost
    self.overdraft_cost = calculate_overdraft_cost
  end
  
end
