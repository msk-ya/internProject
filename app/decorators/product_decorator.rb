# frozen_string_literal: true

module ProductDecorator
  #新規登録時エラーがあった場合の処理
  def errorCheck
    html = ""
    if errors.present?
      html += "<ul class='bg-danger text-white text-center p-2' style:'list-style-tpe:none;'>"
      errors.full_messages.each do |error|
        html += "<li style='text-decoration:none;'>#{error}</li>"
      end
      html += '</ul>'
    end
    return html.html_safe
  end

  #加工法を元にテーブル作成(pc)
  def createProcessTable
    if process.present?
      html = "<table style='margin-top:2%'><tbody><tr><th style='background:blue;color:white;'>可能加工法</th>"
      process.split(',').each do |process|
        html += "<td style='color:brown'>#{I18n.t("enums.processing.status.#{process}")}</td>"
      end
      html += "</tr></tbody></table>"
      return html.html_safe
    end
  end

  #加工法を元にテーブル作成(phone)
  def createProcessTablePhone
    if process.present?
      html = "<table style='margin-top:2%;width:100%;' class='table table-bordered'>
            <tbody><tr><th style='background:blue;color:white;'>可能加工法</th></tr>"
      process.split(',').each do |process|
        html += "<tr><td style='color:brown'>#{I18n.t("enums.processing.status.#{process}")}</td></tr>"
      end
      html += "</tr></tbody></table>"
      return html.html_safe
    end
  end

  #画像表示のためproduct.nameを使ってitem.idに変換する処理
  def productIntoItemImage
      item = Item.find_by(name: name)
      return item.id
  end

  def productShowId
    item = Product.find_by(name: name)
    return item.id
  end
end
