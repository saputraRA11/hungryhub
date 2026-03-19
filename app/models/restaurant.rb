class Restaurant < ApplicationRecord
  has_many :menu_items, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
  validates :opening_hours, presence: true

  def as_json(options = {})
    super(options.merge(only: [ :id, :name, :address, :opening_hours ]))
  end
end
