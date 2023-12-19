require_dependency Rails.root.join("app", "models", "budget").to_s

class Budget
  include Rails.application.routes.url_helpers

  scope :active_budgets, -> { reject(&:finished?) }

  def self.change_phase
    change_active_phases
  end

  private

    def self.change_active_phases
      notifier = SlackNotifier.new
      active_budgets.map do |budget|
        previous_phase = budget.phase
        next_phase = budget.published_phases.find do |phase|
          I18n.l(phase.starts_at.to_date) == I18n.l(Time.zone.now.to_date)
        end
        if next_phase.present?
          budget.phase = next_phase.kind
          if budget.save
            notifier.post text: I18n.t("slack.budgets.phase_change.success",
                                        budget_name: budget.name,
                                        previous_phase: I18n.t("budgets.phase.#{previous_phase}"),
                                        next_phase: I18n.t("budgets.phase.#{next_phase.kind}")
                                      )
          else
            notifier.post text: I18n.t("slack.budgets.phase_change.error")
          end
        end
      end
  end
end
