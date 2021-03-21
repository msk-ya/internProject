# frozen_string_literal: true

module OrderDecorator
  def orderStatusView
    if status == 'in_order'
      return "btn btn-primary "
    elsif status == 'processed'
      return "btn btn-warning"
    elsif status == 'delivery'
      return "btn btn-danger"
    end
  end

  def orderStatusDiv
    if status == 'in_order'
      return "bg-primary p-3 text-white "
    elsif status == 'processed'
      return "bg-warning p-3 text-whit"
    elsif status == 'delivery'
      return "bb-danger p-3 text-whit"
    end
  end

  #画像表示のためorder.nameを使ってitem.idに変換する処理
  def orderItemImage
    item = Item.find_by(name: name)
    return item.id
  end 

 
  def orderShowProductSum
    return price * num
  end

  def orderShowIntoItemImage
    item = Item.find_by(name: name)
    return item.id
  end

  def orderShowProductProcessing
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
  
    
end
