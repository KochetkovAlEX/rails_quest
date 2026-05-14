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
         .to_a # Загружаем данные в память для комбинированной сортировки
         .sort_by { |agent| [-agent.missions.size, agent.codename] }
         .map do |agent|
           # Сортируем миссии текущего агента по алфавиту
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
      Skill.includes(:agents)
         .to_a
         # Сортируем навыки по убыванию числа агентов (-skill.agents.size)
         .sort_by { |skill| -skill.agents.size }
         .map do |skill|
           # Вытаскиваем имена агентов и сортируем их по алфавиту
           agent_names = skill.agents.map(&:codename).sort.join(', ')
           
           "#{skill.name} (#{skill.agents.size}): #{agent_names}"
         end
         .join("\n")
    end
  end
end
