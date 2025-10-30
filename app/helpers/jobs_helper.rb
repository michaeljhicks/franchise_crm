module JobsHelper
  def status_badge(job)
    # Use a case statement to determine the colors based on the job's status
    case job.status.to_sym
    when :completed
      bg_color = "#22C55E" # Green-500
      text_color = "#ffffff"
    when :scheduled
      bg_color = "#3B82F6" # Blue-500
      text_color = "#ffffff"
    when :on_hold
      bg_color = "#F59E0B" # Amber-500
      text_color = "#ffffff"
    when :cancelled
      bg_color = "#6B7280" # Gray-500
      text_color = "#ffffff"
    else
      # A fallback for any other status
      bg_color = "#E5E7EB" # Gray-200
      text_color = "#1F2937" # Gray-800
    end

    # Define the shared styles for the badge
    style = "background-color: #{bg_color}; color: #{text_color}; padding: 0.25em 0.6em; border-radius: 9999px; font-weight: 500; font-size: 0.8em;"

    # Use the content_tag helper to safely build the HTML span tag
    content_tag(:span, job.status.humanize.titleize, style: style)
  end
end