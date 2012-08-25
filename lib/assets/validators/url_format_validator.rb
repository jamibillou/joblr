# encoding: utf-8

class UrlFormatValidator < ActiveModel::EachValidator

  def validate_each(object, attribute, value)
    unless value =~ URI::regexp
      object.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.messages.url_format'))
    end
  end
end