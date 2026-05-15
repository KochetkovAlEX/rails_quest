class Quest2StudentService
  class << self
    # @return [String]
    def all_agents
      Agent.pluck(:codename).join("\n") + "\n"
    end

    # @return [String]
    def all_missions
      # Mission.order(:title)
      Mission.order(:title).pluck(:title).join("\n") + "\n"
    end

    # @return [String]
    def agents_with_missions
      Agent.includes(:missions)
      .order(:codename)
      .map { |agent| "#{agent.codename}: #{agent.missions.pluck(:title).sort.join(', ')}" }
      .join("\n")
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
      Agent.includes(:missions)
         .to_a
         .sort_by { |agent| [-agent.missions.size, agent.codename] }
         .map do |agent|
           mission_titles = agent.missions.map(&:title).sort.join(', ')
           
           "#{agent.codename} (#{agent.missions.size}): #{mission_titles}"
         end
         .join("\n")
    end

    # @return [String]
    def agents_with_skills
      Agent.includes(:skills)
      .order(:codename)
      .map { |agent| "#{agent.codename}: #{agent.skills.pluck(:name).sort.join(', ')}" }
      .join("\n")
    end

    # @return [String]
    def skills_by_agent_count
      # Skill.includes(:agents)
      #    .to_a
      #    .sort_by { |skill| -skill.agents.size }
      #    .map do |skill|
      #      agent_names = skill.agents.map(&:codename).sort.join(', ')
           
      #      "#{skill.name} (#{skill.agents.size}): #{agent_names}"
      #    end
      #    .join("\n")
      Skill.joins(:agents)
        .group('skills.id', 'skills.name')
        .order('COUNT(agents.id) DESC')
        .select("skills.name, COUNT(agents.id) AS agents_count, STRING_AGG(agents.codename, ', ' ORDER BY agents.codename) AS agent_names")
        .map { |skill| "#{skill.name} (#{skill.agents_count}): #{skill.agent_names}" }
        .join("\n")
    end
  end
end