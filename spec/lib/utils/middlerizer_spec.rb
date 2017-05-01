require 'rails_helper'
require 'utils/middlerizer'

describe Middlerizer do
  describe '#middlerized' do
    let(:array) { [5,4,3,2,1] }

    context "without limits specified" do
      subject {
        Middlerizer.new(
          target_object: target_object,
          array: array
        ).middlerized
      }

      context "when target_object is at the beggin of the array" do
        let(:target_object) { array.first }

        it {
              common_expectations(
                upper_half: [4,3,2,1],
                lower_half: [],
                middle: target_object
              )
        }
      end

      context "when target_object is between the beggining and end of the array" do
        context "when is exatcly at the middle" do
          let(:target_object) { array.third }

          it {
                common_expectations(
                  upper_half: [2,1],
                  lower_half: [5,4],
                  middle: target_object
                )
          }
        end

        context "when isn't exatcly at the middle" do
          let(:target_object) { array.second }

          it {
                common_expectations(
                  upper_half: [3,2,1],
                  lower_half: [5],
                  middle: target_object
                )
          }
        end
      end

      context "when target_object is at the end of the array" do
        let(:target_object) { array.last }

        it {
              common_expectations(
                upper_half: [],
                lower_half: [5,4,3,2],
                middle: target_object
              )
        }
      end
    end

    context "with limits specified" do
      subject {
        Middlerizer.new(
          target_object: target_object,
          array: array,
          limits: { upper: 1, lower: 1 }
        ).middlerized
      }

      context "when target_object is at the beggin of the array" do
        let(:target_object) { array.first }

        it {
              common_expectations(
                upper_half: [4],
                lower_half: [],
                middle: target_object
              )
        }
      end

      context "when target_object is between the beggining and end of the array" do
        context "when is exactly at the middle" do
          let(:target_object) { array.third }

          it {
                common_expectations(
                  upper_half: [2],
                  lower_half: [4],
                  middle: target_object
                )
          }
        end

        context "when isn't exatcly at the middle" do
          let(:target_object) { array.second }

          it {
                common_expectations(
                  upper_half: [3],
                  lower_half: [5],
                  middle: target_object
                )
          }
        end
      end

      context "when target_object is at the end of the array" do
        let(:target_object) { array.last }

        it {
              common_expectations(
                upper_half: [],
                lower_half: [2],
                middle: target_object
              )
        }
      end
    end
  end

  private

  def common_expectations(upper_half:, lower_half:, middle:)
    expect(subject[:upper_half]).to eq(upper_half)
    expect(subject[:lower_half]).to eq(lower_half)
    expect(subject[:middle]).to eq(middle)
  end
end
