require 'rails_helper'

RSpec.describe "商品詳細・買い物カゴ", type: :system do
  
    let!(:user){ FactoryBot.create(
      :user, name: 'テスト20210307', name_kana: 'ニーゼロニーイチ', email: '2021@example.com',
      tellnumber: '090-2021-0307', employee: false,
      password: 'password', password_confirmation: 'password'
    )}

    let!(:item1){ FactoryBot.create(:item, name: 'ふぐ', category: 'white', info: '食べ応えがあるフグです')}
    let!(:item2){ FactoryBot.create(:item, name: 'ひらめ', category: 'white', info: '採れたて新鮮なヒラメです')}
    let!(:item3){ FactoryBot.create(:item, name: 'ぶり', category: 'bigger', info: '旬の脂がのったブリです')}
    let!(:item4){ FactoryBot.create(:item, name: 'たこ', category: 'octopassquid', info: '柔らかく食べやすいタコです')}

    let!(:processing1){FactoryBot.create(:processing, name: 'kirimi', item_id: item1.id )} 
    let!(:processing2){FactoryBot.create(:processing, name: 'nimono', item_id: item1.id )} 
    let!(:processing3){FactoryBot.create(:processing, name: 'sasimi', item_id: item4.id )} 
    let!(:processing4){FactoryBot.create(:processing, name: 'sasimi', item_id: item2.id )} 
    let!(:processing5){FactoryBot.create(:processing, name: 'sioyaki', item_id: item3.id )} 

    let!(:product1){ FactoryBot.create(:product, name: 'ふぐ', price: 250, process: 'kirimi', seles_date: Date.today + 1, stock: 15)}
    let!(:product2){ FactoryBot.create(:product, name: 'ふぐ', price: 250, process: 'nimono', seles_date: Date.today + 1, stock: 7)}
    let!(:product3){ FactoryBot.create(:product, name: 'たこ', price: 230, process: 'sasimi', seles_date: Date.today + 1, stock: 18)}
    let!(:product4){ FactoryBot.create(:product, name: 'ひらめ', price: 240, process: 'sasimi', seles_date: Date.today + 1, stock: 26)}
    let!(:product5){ FactoryBot.create(:product, name: 'ぶり', price: 210, process: 'sioyaki', seles_date: Date.today + 1, stock: 28)}

    let!(:basket2){FactoryBot.create(:basket, name: 'ふぐ', price: 250, process: 'nimono', num: 4, user_id: user.id, in_basket_at: '2021-02-25 14:31:00')}
    let!(:basket3){FactoryBot.create(:basket, name: 'たこ', price: 230, process: 'sasimi', num: 3, user_id: user.id, in_basket_at: '2021-02-25 14:32:00')}
    let!(:basket4){FactoryBot.create(:basket, name: 'ひらめ', price: 240, process: 'sashimi', num: 2, user_id: user.id, in_basket_at: '2021-02-25 14:33:00')}
    let!(:basket5){FactoryBot.create(:basket, name: 'ぶり', price: 210, process: 'sioyaki', num: 3, user_id: user.id, in_basket_at: '2021-02-25 14:34:00')} 

    describe "商品詳細画面" do
      before do
        visit login_path
        fill_in "session_email", with: "2021@example.com"
        fill_in "session_password", with: "password"
        click_button 'ログイン'
        visit customer_path(product2.id)
      end 

      it "表示される" do
        expect(page).to have_content '商品詳細' 
      end

      context "商品詳細で選択可能な加工方法のみが表示される" do
        it "表示される" do
          expect(page).to have_content '切り身'
          expect(page).to have_content '煮物'
        end
        it "選択可能な加工方法以外は表示しないこと" do
          expect(page).not_to have_content 'フライ'
          expect(page).not_to have_content '刺身'
          expect(page).not_to have_content '塩焼き'
        end
      end

      context "商品詳細の加工方法押下で買い物カゴに保存できる/商品詳細で選択した商品が表示されること" do
        it "表示される" do
          first(:link, 'お買い物カゴへ').click
          visit edit_customer_basket_path(user.id)
          expect(page).to have_content 'ふぐ'
          expect(page).to have_content '切り身' 
        end
      end
    end

    describe "買い物カゴ画面" do
      before do
        visit login_path
        fill_in "session_email", with: "2021@example.com"
        fill_in "session_password", with: "password"
        click_button 'ログイン'
        visit edit_customer_basket_path(user.id)
      end 

      it "表示される" do
        expect(page).to have_content 'お買い物カゴ' 
      end

      context "ログインしたお客様の買い物かごの中の詳細が表示される" do
        it "表示される" do
          expect(page).to have_content '2,800'
          expect(page).to have_content 'ふぐ'
          expect(page).to have_content 'たこ'
          expect(page).to have_content 'ひらめ'
          expect(page).to have_content 'ぶり'
        end
      end

      context "削除ボタンがあり、買い物かごに入れた商品が削除できる" do
        it "表示される" do
          first(:link, '削除').click
          expect(page).not_to have_content 'ふぐ'
          expect(page).to have_content 'たこ'
          expect(page).to have_content 'ひらめ'
          expect(page).to have_content 'ぶり'
        end
      end

      context "数を変更すると数に合わせた金額になる" do
        it "表示される" do
          select "3", from: "basket-array1"
          click_button '変更を保存する'
          expect(page).to have_content '2,550'
        end
      end

      context "値段が表示されている" do
        it "表示される" do
          expect(page).to have_content '1,000'
          expect(page).to have_content '690'
          expect(page).to have_content '480'
          expect(page).to have_content '630'
        end
      end

      context "合計が表示されている" do
        it "表示される" do
          expect(page).to have_content '2,800'
        end
      end

      context "お会計手続きへボタンが表示されている" do
        it "表示される" do
          expect(page).to have_button 'お会計手続きへ'
        end
      end

      context "変更を保存するボタンが表示されている" do
        it "表示される" do
          expect(page).to have_button '変更を保存する'
        end
      end

      context "お買い物を続けるボタンが表示されている" do
        it "表示される" do
          expect(page).to have_link 'お買い物を続ける'
        end
      end

  end

end
