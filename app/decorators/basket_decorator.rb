# frozen_string_literal: true

module BasketDecorator
  def basketIntoItemImage
    item = Item.find_by(name: name)
    return item.id
  end

  def basketPageBack
    item = Product.find_by(name: name)
    return item.id
  end

  def basketProductProcessing
    case process
    when 'sasimi'
      return '刺身'
    when 'kirimi'
      return '切り身'
    when 'nimono'
      return '煮物'
    when 'sioyaki'
      return '塩焼き'
    when 'flay'
      return 'フライ'
    else
      return '-'
    end
  end

  def basketProductSum
    return price * num
  end

  def basketStockProductNum
    item = Product.find_by(name: name)
    array = []
    (1..item.stock).each do |i|
      array.push(i)
    end
  end

    #新規登録時エラーがあった場合の処理
    def basketErrorCheck
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

end
