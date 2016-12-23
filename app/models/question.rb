class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic 
  extend Enumerize
  KINDS = [:single_choice, :multi_choice, :bool]

  enumerize :kind, in: KINDS
  field :kind, type: String
  field :content, type: String

  field :answer

  validates :content, :kind, :answer, presence: true

  def controller_data
    {
      id: self.id.to_s,
      kind: self.kind,
      content: self.content,
      answer: self.answer,
    }
  end

  def bool_controller_data
    {
      id: self.id.to_s,
      kind: self.kind,
      content: self.content,
      answer: true,
    }
  end

  def single_controller_data
    {
      id: self.id.to_s,
      kind:self.kind,
      content: self.content,
      answer: {
        choices: [],
        correct: 1,
        corrects: [],
      }
    }
  end
end