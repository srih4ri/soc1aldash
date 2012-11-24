require 'spec_helper'

describe User do
  it {should have_many(:social_apps)}
end
