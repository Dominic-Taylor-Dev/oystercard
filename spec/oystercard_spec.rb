require_relative '../lib/oystercard'

describe Oystercard do
  it "should initialize with a balance of zero" do
    expect(subject.balance).to eq(0)
  end

  describe '#top_up' do
    it "can increase balance" do
      expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
    end

    it "throws exception if trying to top up to more than max balance" do
      expect{ subject.top_up (Oystercard::MAX_BALANCE + 1) }.to raise_error('Max balance is #{MAX_BALANCE}')
    end
  end
end
