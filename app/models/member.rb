class Member
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :job_number, type: String

  validates :name, :job_number, presence: true

  has_and_belongs_to_many :organization_nodes
  belongs_to :user

  def controller_data
    {
      id: self.id.to_s,
      name: self.name,
      email:  if self.user == nil
                ''
              else
                self.user.email
              end,
      job_number: self.job_number,
      organization_nodes: self.organization_nodes.map {|x| x.controller_data},
    }
  end
end