class MenuItem < ApplicationRecord
  CATEGORIES = %w[appetizer main dessert drink].freeze
  belongs_to :restaurant
  enum :category, CATEGORIES.index_by(&:itself)
end
