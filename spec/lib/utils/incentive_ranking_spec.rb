require 'rails_helper'
require 'utils/incentive_ranking'

include IncentiveRanking

describe IncentiveRanking do
  let(:team) { create(:team) }
  let(:records) { UserScore.by_team(team) }

  describe ".user_index" do
    let(:selected_user) { create(:user) }

    before do
      team.enroll(selected_user)
      4.times { team.enroll(create(:user)) }
    end

    it "returns the table row index from the UserScore that the selected user belongs" do
      idx = described_class.send(:user_index, records, selected_user)
      expect(records[idx].user).to eq(selected_user)
    end

    context "when selected user is not found" do
      let(:wrong_user) { create(:user) }

      it "raises an error" do
        expect { described_class.send(:user_index, records, wrong_user) }.to raise_error(RuntimeError)
      end
    end
  end

  describe ".array_last_index" do
    before { 4.times { team.enroll(create(:user)) } }

    it "returns the last index according the direction" do
      each_direction do |direction|
        received = described_class.send(:array_last_index, records, direction)
        expected = direction == :downto ? 0 : records.count - 1
        expect(received).to eq(expected)
      end
    end
  end

  describe ".number_of_records" do
    before { 4.times { team.enroll(create(:user)) } }

    it "returns the correct number of records" do
      each_direction do |direction|
        records.count.times do |selected_index|
          received = described_class.send(:number_of_records, records,
                                          selected_index, direction)
          expected = expected_number_of_records(records, selected_index, direction)
          expect(received).to eq(expected)
        end
      end
    end
  end

  describe ".last_index_to_get" do
    context "when direction is from middle to the beginning -->" do
      before { 4.times { team.enroll(create(:user)) } }

      context "when no limit is specified -->" do
        context "when the selected index isn't the edge" do
          it "returns the last index" do
            each_direction do |direction|
              array_indexes_to_test(records, direction).each do |selected_index|
                received = described_class.send(:last_index_to_get, records,
                                                 selected_index, direction)
                expected = described_class.send(:array_last_index, records,
                                                direction)
                expect(received).to eq(expected)
              end
            end
          end
        end

        context "when the selected index is the edge" do
          it "returns nil" do
            each_direction do |direction|
              edge_index = array_edge_index(records, direction)
              received = described_class.send(:last_index_to_get, records,
                                              edge_index, direction)
              expect(received).to be_nil
            end
          end
        end
      end

      context "when limit is specified -->" do
        let(:limit) { 1 }

        context "when the selected index isn't the edge" do
          it "returns the index respecting the specified limit" do
            each_direction do |direction|
              array_indexes_to_test(records, direction).each do |selected_index|
                received = described_class.send(:last_index_to_get, records,
                                                 selected_index, direction, limit)
                expected = last_index_according_limit(selected_index, limit, direction)
                expect(received).to eq(expected)
              end
            end
          end
        end

        context "when the selected index is the edge" do
          it "returns nil" do
            each_direction do |direction|
              edge_index = array_edge_index(records, direction)
              received = described_class.send(:last_index_to_get, records,
                                              edge_index, direction, limit)
              expect(received).to be_nil
            end
          end
        end
      end
    end

    describe ".desired_records" do
      before { 4.times { team.enroll(create(:user)) } }

      context "when limit is specified" do

      end

      context "when limit isn't specified -->" do
        context "when selected index isn't the edge" do
          it "retuns the right recods" do
            each_direction do |direction|
              array_indexes_to_test(records, direction).each do |selected_index|
                received = described_class.send(:desired_records, records,
                                                selected_index, direction)
                expected = expected_records(records, selected_index, direction)
                expect(received).to eq(expected)
              end
            end
          end
        end

        context "when selected index is the edge" do
          it "return nil" do
            each_direction do |direction|
              edge_index = array_edge_index(records, direction)
              received = described_class.send(:desired_records, records,
                                               edge_index, direction)
              expect(received).to be_nil
            end
          end
        end
      end

      context "when limit is specified -->" do
        let(:limit) { 1 }

        context "when selected index isn't the edge" do
          it "retuns the right recods respecting the specified limit" do
            each_direction do |direction|
              array_indexes_to_test(records, direction).each do |selected_index|
                received = described_class.send(:desired_records, records,
                                                selected_index, direction, limit)
                expected = expected_records(records, selected_index, direction,
                                            limit)
                expect(received).to eq(expected)
              end
            end
          end
        end

        context "when selected index is the edge" do
          it "returns nil" do
            each_direction do |direction|
              edge_index = array_edge_index(records, direction)
              received = described_class.send(:desired_records, records,
                                               edge_index, direction, limit)
              expect(received).to be_nil
            end
          end
        end
      end
    end

    describe ".join_records" do
      let(:array) { [0] }
      let(:to_add) { [1,2,3] }
      let(:expected) { { downto: (to_add + array),
                         upto: (array + to_add) } }

      it "add the records in the right position" do
        each_direction do |direction|
          received = described_class.send(:join_records, array, to_add, direction)
          expect(received).to eq(expected[direction])
        end
      end
    end

    describe ".rank" do
      before { 4.times { team.enroll(create(:user)) } }

      context "when limit is specified" do
        let(:limits) { { downto: 1, upto: 2 } }

        context "when user is the first record" do
          let(:selected_user) { records.first.user }
          let(:expected) { records[0..2] }

          it "returns the right records respecting the specified limit" do
            received = described_class.rank(selected_user, team, limits)
            expect(received).to eq(expected)
          end
        end

        context "when user is the last record" do
          let(:selected_user) { records.last.user }
          let(:expected) { [records[-2], records.last] }

          it "returns the right records respecting the specified limit" do
            received = described_class.rank(selected_user, team, limits)
            expect(received).to eq(expected)
          end
        end

        context "when user in the middle of the records" do
          let(:selected_user) { records[1].user }
          let(:expected) { records }

          it "returns the right records respecting the specified limit" do
            received = described_class.rank(selected_user, team, limits)
            expect(received).to eq(expected)
          end
        end
      end

      context "when limit isn't specified" do
        let(:selected_user) { records[2].user }

        it "returns all records" do
          received = described_class.rank(selected_user, team)
          expect(received).to eq(records)
        end
      end
    end

    describe ".build" do
      let(:selected_user) { records[2].user }
      let(:limits) { { upto: 1, downto: 1, answers: 1 } }
      let(:ranking) { described_class.build(selected_user, team, limits) }

      before do
        4.times { team.enroll(create(:user)) }
        User.all.each { |user| create_pair(:answer, user: selected_user, team: team) }
        UserScore.all.each.inject(0) do |score, user_score|
          user_score.update_attributes(score: score)
          score += 1
        end
      end

      it "returns an array of hashes whit the right data" do
        expect(ranking.count).to eq(3)

        ranking.each do |object|
          expected = records.where(user: object[:user]).first
          expect(object[:score]).to eq(expected.score)
          expect(object[:answers].count).to eq(limits[:answers])
          expect(object[:answers].first.user).to eq(selected_user)
          expect(object[:answers].first.team).to eq(team)
        end

        # Check if is ordered by score.
        (records.count - 2).times do |idx|
          expect(records[idx][:score] >= records[idx + 1][:score] )
        end
      end
    end
  end

    private

    # Expected number of records disconsidering the selected record
    # (selected_index) itself.
    def expected_number_of_records(records, selected_index, direction)
      return selected_index if direction == :downto
      selected_index.send(direction, described_class.send(:array_last_index,
                                                          records,
                                                          direction)).count - 1
    end

    # The indexes are all except the edge (this is tested separately).
    def array_indexes_to_test(records, direction)
      return (1...records.count).to_a if direction == :downto
      (0...array_edge_index(records, direction)).to_a
    end

    # The edge is the "last" array index considering the direction.
    def array_edge_index(records, direction)
      return 0 if direction == :downto
      records.count - 1
    end

    # Last index to get in the specified direction, respecting the specified
    # limit.
    def last_index_according_limit(selected_index, limit, direction)
      return selected_index - limit if direction == :downto
      selected_index + limit
    end

    # Iterates over the directions.
    def each_direction
      IncentiveRanking::DIRECTIONS_ORDER.each { |direction| yield(direction) }
    end

    def expected_records(records, selected_index, direction, limit = nil)
      last_index = described_class.send(:last_index_to_get, records,
                                        selected_index, direction, limit)
      indexes = get_expected_records_indexes(selected_index, last_index, direction)
      indexes.each.inject([]) { |array, index| array << records[index] }
    end

    # Get the indexes of the expected records, excluding the selected index at
    # the end (it will be in the edge, so according the direction, we 'pop' or
    # 'shift' it from the array).
    def get_expected_records_indexes(selected_index, last_index, direction)
      index_range = [selected_index, last_index].sort
      indexes = (index_range[0]).upto(index_range[1]).to_a
      if direction == :downto then indexes.pop else indexes.shift end
      indexes
    end
end
