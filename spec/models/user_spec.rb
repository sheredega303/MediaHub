require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_length_of(:channel_name).is_at_most(100) }

  it { is_expected.to have_many(:videos).dependent(:destroy) }
end
