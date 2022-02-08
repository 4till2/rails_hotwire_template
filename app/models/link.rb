class Link < ApplicationRecord
  validates :url, url: { allow_nil: true }
end
