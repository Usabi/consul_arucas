require_dependency Rails.root.join("lib", "admin_wysiwyg_sanitizer").to_s

class AdminWYSIWYGSanitizer
  def allowed_tags
    super + %w[img table caption thead tbody tr th td iframe]
  end

  def allowed_attributes
    super + %w[alt src align border cellpadding cellspacing dir style class summary scope id width height]
  end
end
