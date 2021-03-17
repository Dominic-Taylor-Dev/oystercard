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
      context 'when card used to touch in at doubled station' do
        let(:entry_station) { double :entry_station }
        let(:exit_station) { double :exit_station }

        before(:each) do
          subject.touch_in(entry_station)
        end

        it 'changes in_journey status to true' do
          expect(subject.in_journey?).to eq(true)
        end

        it 'sets entry station' do
          expect(subject.journey[:entry_station]).to eq(entry_station)
        end

        describe '#touch_out' do
          it 'changes in_journey status from true to false' do
            subject.touch_out(exit_station)
            expect(subject.in_journey?).to eq(false)
          end

          it 'decreases balance by minimum balance (£1) when touching out' do
            expect { subject.touch_out(exit_station) }.to change { subject.balance }.by(-Oystercard::MIN_CHARGE)
          end
        end
      end
    end
  end

  describe '#in_journey?' do
    it 'in_journey should be false by default' do
      expect(subject).not_to be_in_journey
    end
  end

  describe '#history' do
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }

  before(:each) do
    subject.top_up(10)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
  end

  it 'returns instance variable with entry and exit station recorded' do
    expect(subject.history).to include({entry_station: entry_station, exit_station: exit_station})
  end
  end
end
