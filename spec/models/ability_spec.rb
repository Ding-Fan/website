require 'rails_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  subject { ability }

  context 'Admin manage all' do
    let(:admin) { create :admin }
    let(:ability) { Ability.new(admin) }

    it { is_expected.to be_able_to(:manage, Topic) }
    it { is_expected.to be_able_to(:manage, Reply) }
    it { is_expected.to be_able_to(:manage, Section) }
    it { is_expected.to be_able_to(:manage, Node) }
    it { is_expected.to be_able_to(:manage, file) }
    it { is_expected.to be_able_to(:manage, Comment) }
  end

  context 'Wiki Editor manage wiki' do
    let(:wiki_editor) { create :wiki_editor }
    let(:ability) { Ability.new(wiki_editor) }

    it { is_expected.not_to be_able_to(:suggest, Topic) }
    it { is_expected.not_to be_able_to(:unsuggest, Topic) }
  end

  context 'Normal users' do
    let(:user) { create :avatar_user }
    let(:topic) { create :topic, user: user }
    let(:topic1) { create :topic }
    let(:locked_topic) { create :topic, user: user, lock_node: true }
    let(:reply) { create :reply, user: user }
    let(:note) { create :note, user: user }
    let(:comment) { create :comment, user: user, commentable: CommentablePage.create(name: 'Fake Wiki', id: 1)}
    let(:note_publish) { create :note, publish: true }

    let(:ability) { Ability.new(user) }

    context 'Topic' do
      it { is_expected.to be_able_to(:read, Topic) }
      it { is_expected.to be_able_to(:create, Topic) }
      it { is_expected.to be_able_to(:update, topic) }
      it { is_expected.to be_able_to(:destroy, topic) }
      it { is_expected.not_to be_able_to(:suggest, Topic) }
      it { is_expected.not_to be_able_to(:unsuggest, Topic) }
      it { is_expected.not_to be_able_to(:ban, Topic) }
      it { is_expected.not_to be_able_to(:open, topic1) }
      it { is_expected.not_to be_able_to(:close, topic1) }
      it { is_expected.not_to be_able_to(:ban, topic) }
      it { is_expected.to be_able_to(:open, topic) }
      it { is_expected.to be_able_to(:close, topic) }
      it { is_expected.to be_able_to(:change_node, topic) }
      it { is_expected.not_to be_able_to(:change_node, locked_topic) }
      it { is_expected.to be_able_to(:change_node, topic) }
    end

    context 'Reply' do
      context 'normal' do
        it { is_expected.to be_able_to(:read, Reply) }
        it { is_expected.to be_able_to(:create, Reply) }
        it { is_expected.to be_able_to(:update, reply) }
        it { is_expected.to be_able_to(:destroy, reply) }
      end

      context 'Reply that Topic closed' do
        let(:t) { create(:topic, closed_at: Time.now) }
        let(:r) { Reply.new(topic: t) }

        it { is_expected.not_to be_able_to(:create, r) }
        it { is_expected.not_to be_able_to(:update, r) }
        it { is_expected.not_to be_able_to(:destroy, r) }
      end
    end

    context 'Section' do
      it { is_expected.to be_able_to(:read, Section) }
    end

    context 'file' do
      it { is_expected.to be_able_to(:create, file) }
      it { is_expected.to be_able_to(:read, file) }
    end

    context 'Comment' do
      it { is_expected.to be_able_to(:create, Comment) }
      it { is_expected.to be_able_to(:read, Comment) }
      it { is_expected.to be_able_to(:update, comment) }
      it { is_expected.to be_able_to(:destroy, comment) }
    end
  end

  context 'Normal user but no avatar' do
    let(:user) { create :user }
    let(:ability) { Ability.new(user) }

    it { is_expected.to be_able_to(:create, Topic) }
  end

  context 'Newbie users' do
    let(:newbie) { create :newbie }
    let(:ability) { Ability.new(newbie) }

    context 'Topic' do
      it { is_expected.not_to be_able_to(:create, Topic) }
      it { is_expected.not_to be_able_to(:suggest, Topic) }
      it { is_expected.not_to be_able_to(:unsuggest, Topic) }
    end

    context 'Reply' do
      it { is_expected.to be_able_to(:create, Reply) }
    end
  end

  context 'Blocked users' do
    let(:blocked_user) { create :blocked_user }
    let(:ability) { Ability.new(blocked_user) }

    context 'Topic' do
      it { is_expected.not_to be_able_to(:create, Topic) }
    end
    context 'Reply' do
      it { is_expected.not_to be_able_to(:create, Reply) }
    end
    context 'Comment' do
      it { is_expected.not_to be_able_to(:create, Comment) }
    end
    context 'file' do
      it { is_expected.not_to be_able_to(:create, file) }
    end
  end

  context 'Deleted users' do
    let(:deleted_user) { create :deleted_user }
    let(:ability) { Ability.new(deleted_user) }
    context 'Topic' do
      it { is_expected.not_to be_able_to(:create, Topic) }
    end
    context 'Reply' do
      it { is_expected.not_to be_able_to(:create, Reply) }
    end
    context 'Comment' do
      it { is_expected.not_to be_able_to(:create, Comment) }
    end
    context 'file' do
      it { is_expected.not_to be_able_to(:create, file) }
    end
  end
end
