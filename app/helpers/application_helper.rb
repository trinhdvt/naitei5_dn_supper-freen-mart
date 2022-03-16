module ApplicationHelper
  include Pagy::Frontend

  def full_title page_title
    base_title = t "base_title"
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def toastr_flash
    toastr_options = "{closeButton: true, progressBar: true}"

    toastr_js = []
    flash.each do |type, msg|
      type = "success" if type == "notice"
      type = "error" if type == "alert"
      js = "toastr.#{type}('#{msg}','',#{toastr_options});"
      toastr_js << js if msg
    end

    sanitize("<script>#{toastr_js.join('\n')}</script>") if toastr_js.present?
  end
end
