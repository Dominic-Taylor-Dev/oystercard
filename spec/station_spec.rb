# frozen_string_literal: true

require 'spec_helper'
require 'station'

describe Station do
  subject = Station.new('Westminster', 1)
  it 'has a name' do
    expect(subject.name).to eq('Westminster')
  end

  it 'has a zone ' do
    expect(subject.zone).to eq(1)
  end
end
