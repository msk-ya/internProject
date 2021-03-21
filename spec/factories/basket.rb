FactoryBot.define do
  factory :basket do
    name { "さば" }
    price{ 100 }
    process{ "sasimi" }
    num { 5 }
    in_basket_at{ DateTime.now }
    user
  end
end