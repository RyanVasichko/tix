module ToastMessagesHelper
  def turbo_append_toast_messages
    turbo_stream.append "toast_messages" do
      flash.each do |message_type, message|
        render "shared/toast_messages/toast_message", { message_type: message_type, message: message }
      end
    end
  end
end