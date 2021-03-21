FactoryBot.define do
    factory :product do
      name { "fish" }
      price{ 200 }
      process{ "sasimi" }
      stock{ 30 }
      seles_date{ Date.today }
    end
end