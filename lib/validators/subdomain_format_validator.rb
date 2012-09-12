# encoding: utf-8

class SubdomainFormatValidator < ActiveModel::EachValidator

  def validate_each(object, attribute, value)
    unless value =~ /^([a-z\d]+(-|_)?[a-z\d]+)+$/
      object.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.messages.subdomain_format'))
    end
  end
end