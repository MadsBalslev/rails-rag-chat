class MessageChunk < ApplicationRecord
  belongs_to :message
  belongs_to :chunk
end
