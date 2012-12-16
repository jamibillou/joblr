require 'spec_helper'

describe FeedbackEmail do

  describe 'Validations' do
    it { should validate_presence_of :page }
  end
end
