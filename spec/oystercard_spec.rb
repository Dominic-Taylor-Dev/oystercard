# frozen_string_literal: true

require_relative '../lib/oystercard'

describe Oystercard do
  it 'should initialize with a balance of zero' do
    expect(subject.balance).to eq(0)
  end

  describe '#top_up' do
    it 'can increase balance' do
      expect { subject.top_up 1 }.to change { subject.balance }.by 1
    end

    it 'throws exception if trying to top up to more than max balance' do
      expect { subject.top_up(Oystercard::MAX_BALANCE + 1) }.to raise_error("Max balance is #{Oystercard::MAX_BALANCE}")
    end
  end

  context 'when balance starts non-zero (10)' do
    before(:each) do
      subject.top_up(10)
    end
    
    describe '#touch_in' do
      it 'changes in_journey status from false to true' do
        subject.touch_in
        expect(subject.in_journey?).to eq(true)
      end
    end
  
    describe '#touch_out' do
      it 'changes in_journey status from true to false' do
        subject.touch_in
        subject.touch_out
        expect(subject.in_journey?).to eq(false)
      end
    end

    describe '#deduct' do
      it 'can decrease balance' do
        expect { subject.deduct 1 }.to change { subject.balance}. by(-1)
      end

      it 'throws an exception if trying to deduct more than min balance allows' do
        expect { subject.deduct(subject.balance - Oystercard::MIN_BALANCE + 1)}.to raise_error("Min balance is #{Oystercard::MIN_BALANCE}")
      end
    end
  end

  describe '#in_journey?' do
    it 'in_journey should be false by default' do
      expect(subject).not_to be_in_journey
    end
  end
end
