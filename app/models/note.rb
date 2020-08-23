class Note < ApplicationRecord
  belongs_to :user #shows that note and model are connected through a referenced relationship
end
