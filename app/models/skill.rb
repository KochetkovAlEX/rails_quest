class Skill < ApplicationRecord
    has_many :missions
    has_many :agent_skills
    has_many :agents, through: :agent_skills

    validates :name, presence: true, uniqueness: true
    validates :category, presence: true
end
