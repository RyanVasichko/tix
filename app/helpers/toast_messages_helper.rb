module ToastMessagesHelper
  def turbo_append_toast_messages
    turbo_stream.append("toast_messages") do
      flash.each do |message_type, message|
        concat(render "shared/toast_messages/toast_message", { message_type: message_type, message: message })
      end
    end
  end

  def color_for_toast_message_type(message_type)
    case message_type.to_sym
    when :success
      "green"
    when :error
      "red"
    when :alert
      "yellow"
    when :notice
      "indigo"
    else
      message_type.to_s
    end
  end
end
