# Errors
# ------

def errors(attribute, type)
  "#{I18n.t("activerecord.attributes.#{attribute}")} #{I18n.t("activerecord.errors.messages.#{type}")}."
end