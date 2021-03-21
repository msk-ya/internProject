module Customer::BasketsHelper

  def basketProcessProcessing(name)
    case name
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
