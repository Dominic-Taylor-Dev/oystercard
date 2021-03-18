# frozen_string_literal: true

require 'oystercard'
require 'journey'

describe Oystercard do
  it 'has a balance of zero' do
    expect(subject.balance).to eq(0)
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up the balance' do
      expect { subject.top_up(1) }.to change { subject.balance }.by 1
    end

    it 'cannot exceed balance limit total' do
      balance_limit = Oystercard::BALANCE_LIMIT + 1
      expect { subject.top_up(balance_limit) }.to raise_error("top up limit of £#{Oystercard::BALANCE_LIMIT} reached")
    end
  end

  context 'when used to touch in at station' do
    let(:entry_station) { double :entry_station }
    let(:exit_station) { double :exit_station }

    describe '#touch_in' do
      it 'can touch in' do
        subject.top_up(60)
        expect(subject.touch_in(entry_station)).to be_truthy
      end

      it 'raises error if card has insufficient funds' do
        subject.top_up(Oystercard::BALANCE_MINIMUM)
        expect { subject.touch_in(entry_station) }.to raise_error('Insufficient funds')
      end

      it 'records entry station' do
        subject.top_up(60)
        subject.touch_in(entry_station)
        expect(subject.journey.entry_station).to eq(entry_station)
      end

      it 'deducts penalty fare if you touch in twice in a row' do
        subject.top_up(60)
        subject.touch_in(entry_station)
        expect { subject.touch_in(entry_station) }.to change { subject.balance }.by(-Journey::PENALTY_FARE)
      end
    end

    describe '#touch_out' do
      it 'can touch out' do
        subject.top_up(3)
        subject.touch_in(entry_station)
        expect(subject.touch_out(exit_station)).to be_falsey
      end

      it 'can deduct from the balance' do
        subject.top_up(10)
        subject.touch_in(entry_station)
        expect { subject.touch_out(exit_station) }.to change { subject.balance }.by(-1)
      end

      it 'deducts penalty fare if you touch out  without touching in' do
        subject.top_up(60)
        expect { subject.touch_out(exit_station) }.to change { subject.balance }.by(-Journey::PENALTY_FARE)
      end
    end
  end
end
