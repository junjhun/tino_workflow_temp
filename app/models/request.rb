class Request < ApplicationRecord
    # include WorkflowActiverecord

    validates :name, presence: true, uniqueness: true
  
    # DRAFT = 'draft'
    # REVIEWED = 'reviewed'
    # PUBLISHED = 'published'
  
    # workflow do
    #   state DRAFT do
    #     event :peer_review, transitions_to: REVIEWED
    #   end
    #   state REVIEWED do
    #     event :publish, transitions_to: PUBLISHED
    #   end
    # end
end
