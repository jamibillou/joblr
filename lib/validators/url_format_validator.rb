# encoding: utf-8

class UrlFormatValidator < ActiveModel::EachValidator

  def validate_each(object, attribute, value)
    unless value =~ /^((?:https?:\/\/|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))$/xi
      object.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.messages.url_format'))
    end
  end
end