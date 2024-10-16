require 'rails_helper'

RSpec.describe Video, type: :model do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(255) }
  it { is_expected.to validate_presence_of(:age_rating) }
  it { is_expected.to validate_inclusion_of(:age_rating).in_array(%w[G PG PG-13 R NC-17]) }
  it { is_expected.to have_one_attached(:file) }
end
