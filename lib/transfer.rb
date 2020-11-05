require_relative './bank_account.rb'

class Transfer
attr_accessor :sender, :receiver, :status, :amount
@@all = []

  def initialize(sender, receiver, amount)
    @sender = sender
    @receiver = receiver
    @status = "pending"
    @amount = amount
    self.class.all << self
  end

  def valid?
    @sender.valid? && @receiver.valid?
  end

  def reject_transfer?
    !valid? || @sender.balance < @amount || @status == "complete"
  end

  def reject_reverse?
    !valid? || @receiver.balance < @amount || @status != "complete"
  end

  def execute_transaction
    if reject_transfer?
      @status = "rejected"
      "Transaction rejected. Please check your account balance."
    else
      @sender.deposit(-@amount)
      @receiver.deposit(@amount)
      @status = "complete"
    end
  end

  def reverse_transfer
    if reject_reverse?
      "Transaction rejected. Please check your account balance."
    else
      @sender.deposit(@amount)
      @receiver.deposit(-@amount)
      @status = "reversed"
    end
  end


  def self.all
    @@all
  end

end
