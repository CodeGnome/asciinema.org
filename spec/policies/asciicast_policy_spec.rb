require 'rails_helper'

describe AsciicastPolicy do

  subject { described_class }

  describe '#permitted_attributes' do
    subject { Pundit.policy(user, asciicast).permitted_attributes }

    let(:asciicast) { Asciicast.new }

    context "when user is admin" do
      let(:user) { stub_model(User, admin?: true) }

      it "includes featured" do
        expect(subject).to eq([:title, :description, :theme_name, :featured])
      end
    end

    context "when user isn't admin" do
      let(:user) { stub_model(User, admin?: false) }

      it "is empty" do
        expect(subject).to eq([])
      end

      context "and is creator of the asciicast" do
        let(:asciicast) { Asciicast.new(user: user) }

        it "doesn't include featured but includes private" do
          expect(subject).to eq([:title, :description, :theme_name, :private])
        end
      end
    end
  end

  permissions :update? do
    it "denies access if user is nil" do
      expect(subject).not_to permit(nil, Asciicast.new)
    end

    it "grants access if user is admin" do
      user = stub_model(User, admin?: true)
      expect(subject).to permit(user, Asciicast.new)
    end

    it "grants access if user is creator of the asciicast" do
      user = stub_model(User, admin?: false)
      expect(subject).to permit(user, Asciicast.new(user: user))
    end

    it "denies access if user isn't the creator of the asciicast" do
      expect(subject).not_to permit(User.new, Asciicast.new(user: User.new))
    end
  end

  permissions :destroy? do
    it "denies access if user is nil" do
      expect(subject).not_to permit(nil, Asciicast.new)
    end

    it "grants access if user is admin" do
      user = stub_model(User, admin?: true)
      expect(subject).to permit(user, Asciicast.new)
    end

    it "grants access if user is creator of the asciicast" do
      user = stub_model(User, admin?: false)
      expect(subject).to permit(user, Asciicast.new(user: user))
    end

    it "denies access if user isn't the creator of the asciicast" do
      expect(subject).not_to permit(User.new, Asciicast.new(user: User.new))
    end
  end

  permissions :feature? do
    it "denies access if user is nil" do
      expect(subject).not_to permit(nil, Asciicast.new)
    end

    it "grants access if user is admin" do
      user = stub_model(User, admin?: true)
      expect(subject).to permit(user, Asciicast.new)
    end

    it "denies access if user isn't admin" do
      user = stub_model(User, admin?: false)
      expect(subject).not_to permit(user, Asciicast.new)
    end
  end

  permissions :unfeature? do
    it "denies access if user is nil" do
      expect(subject).not_to permit(nil, Asciicast.new)
    end

    it "grants access if user is admin" do
      user = stub_model(User, admin?: true)
      expect(subject).to permit(user, Asciicast.new)
    end

    it "denies access if user isn't admin" do
      user = stub_model(User, admin?: false)
      expect(subject).not_to permit(user, Asciicast.new)
    end
  end

  permissions :make_public? do
    let(:asciicast) { Asciicast.new }

    it "denies access if user is nil" do
      expect(subject).not_to permit(nil, asciicast)
    end

    it "grants access if user is owner of the asciicast" do
      user = stub_model(User)
      asciicast.user = user
      expect(subject).to permit(user, asciicast)
    end

    it "denies access if user isn't owner of the asciicast" do
      user = stub_model(User)
      asciicast.user = stub_model(User)
      expect(subject).not_to permit(user, asciicast)
    end
  end

  permissions :make_private? do
    let(:asciicast) { Asciicast.new }

    it "denies access if user is nil" do
      expect(subject).not_to permit(nil, asciicast)
    end

    it "grants access if user is owner of the asciicast" do
      user = stub_model(User)
      asciicast.user = user
      expect(subject).to permit(user, asciicast)
    end

    it "denies access if user isn't owner of the asciicast" do
      user = stub_model(User)
      asciicast.user = stub_model(User)
      expect(subject).not_to permit(user, asciicast)
    end
  end

end
