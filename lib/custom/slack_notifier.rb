class SlackNotifier
  def initialize
    @notifier = Slack::Notifier.new Rails.application.secrets.slack_webhook_url do
      defaults channel: Rails.application.secrets.slack_chanel,
               username: "[Participa Arucas]",
               icon_emoji: ":classical_building:",
               additional_parameters: {
                 mrkdwn: true
               }
    end
  end

  def post(options = {})
    @notifier.post(options)
  end
end
