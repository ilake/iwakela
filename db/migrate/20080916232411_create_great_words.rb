class CreateGreatWords < ActiveRecord::Migration
  def self.up
    create_table :great_words do |t|
      t.text :content 
      t.belongs_to :user
    end

#    u= User.find_by_email('lake.ilakela@gmail.com')
#    u.great_words.create(:content => '人生跟戲一樣,好看的是那份認真')
#    u.great_words.create(:content => '「沒有經過反省的人生，是不值得活的」 by 蘇格拉底')
#    u.great_words.create(:content => '「當生命給你苦澀的檸檬，你就把檸檬榨成檸檬汁」 by 宗才怡')
#    u.great_words.create(:content => '「你吸收什麼樣的資訊，會決定你成為什麼樣的人」 by 余振忠--惠普科技董事長')
#    u.great_words.create(:content => '「命運是你自己創造的， 這是你的天賦，不要蹧踏它。」 by 電影--人骨拼圖')
#    u.great_words.create(:content => '「有許多決定，不見得會毀了你的一生，但是足以改變你的餘生。」 by 椰林風情--movieduck')
#    u.great_words.create(:content => '「你只能活一次，你沒有機會失敗。」 by  伊哥拉--德國林后之一')
#    u.great_words.create(:content => '「痛苦並不是一件壞事，除非痛苦征服了我們。」')
#    u.great_words.create(:content => 'LIFE IS A BALL 起起伏伏.....重要的是不要洩氣.......')
#    u.great_words.create(:content => '人生就像一盒巧克力一樣  你永遠不知道下一個會拿到的是什麼 by 阿甘正傳')
#    u.great_words.create(:content => '獲得生命的訣竅不僅僅是活著，而在於，為了什麼而活。 ──杜斯妥也夫斯基')
#    u.great_words.create(:content => '在大家都不看好的時候，就是精采傳奇的開始。')
#    u.great_words.create(:content => '無論做什麼,每一個人都在世界歷史上扮演了 重要的角色,而通常他本身並不自知 →牧羊少年的奇幻之旅←')
#    u.great_words.create(:content => '生命是一段連續的過程, 所有的一切都環環相扣')
#    u.great_words.create(:content => '                逃避不一定躲得過, 面對不一定最難受
#    
#                    孤單不一定不快樂, 得到不一定能長久
#                    
#                                    失去不一定不再有, 轉身不一定最軟弱')
#    u.great_words.create(:content => '我不想在生命走到盡頭時才發現除了年齡，我什麼都沒有.....
#    
#    我要我的生命盡量的寬廣。
#    
#                                 --戴安娜.安克曼')
#    u.great_words.create(:content => '生命究竟有沒有意義並非我的責任
#    
#    但是怎樣安排此生卻是我的責任
#    
#                                    <青年的四個大夢>')
#    u.great_words.create(:content => '累累的創傷
#    
#    　　　　　就是生命給你最好的東西
#    
#    　　　　　　　　　　　　　　　　因為在每個創傷上面都標誌著前進的一步
#    
#    (法) 羅曼．羅蘭')
#    u.great_words.create(:content => '老了沒有回憶不打緊
#    
#              怕的是留下了一堆後悔')
#    u.great_words.create(:content => '即使明天世界將毀滅 我今天仍要栽下葡萄樹
#                                           by--馬丁路德')
#    u.great_words.create(:content => '         心若改變，你的態度跟著改變。
#    
#               態度改變，你的習慣跟著改變。
#               
#                        習慣改變，你的性格跟著改變。
#                        
#                                   性格改變，你的人生跟著改變。')
#    u.great_words.create(:content => '我不要等我死後才發現自己沒活過.....
#    
#                                  ------<春風化雨>')
#    u.great_words.create(:content => '我們每個人都像小丑一樣，每天都玩著五顆球，
#    
#    那五顆球分別是，工作、健康、家庭、朋友、靈魂...
#    
#    但是其中卻只有一顆是橡膠做的，掉下去會再彈起來....那就是工作。
#    
#    其他的四顆都是用玻璃做的，掉了，就碎了...')
#    u.great_words.create(:content => '「年輕人通常會後悔做過某些事，而年長者則後悔 未曾做過某些事。」')
#    u.great_words.create(:content => '夢想,需要的不是觀望,而是參與!')
#    u.great_words.create(:content => '『對不知的未來我們唯一能帶入方程式的，就是我們的態度；
#    
#      而態度，決定一個人的高度。因為我知道，我將來要跟一般人競爭的，
#      
#        不是我身體的高度，而是我對人生堅決的態度』－生命鬥士  朱仲祥')
#    u.great_words.create(:content => '先立下10年後的計劃,就容易看出目前的計劃')
#    u.great_words.create(:content => '為愛你的人和你愛的人活下去。')
#    u.great_words.create(:content => '泰戈爾：「願生如夏花之絢爛，死如秋葉之靜美。」')
#    u.great_words.create(:content => '人生猶如一本書
#      愚蠢的人們把它草草翻過
#        聰明的人把它細細閱讀
#          為什麼呢?
#            因為他知道能唸它一次
#                                      BY 堅.保羅')
#    u.great_words.create(:content => '人怎麼樣才能富有呢
#     最好就是，做自己喜歡的事。 by 電影「蝴蝶」')
#    u.great_words.create(:content => '學問：多學多問，學著發問 --郭台銘')
#    u.great_words.create(:content => '大部分人都是用自己的早年 造成晚年的悲哀 ------布呂耶爾')
#    u.great_words.create(:content => '你們半是理想家，半是功利家, 你們的理想叫你們想得太高太遠不顧實際；
#     同時你們的功利精神又不敢冒任何風險。---馬森‧夜遊')
#    u.great_words.create(:content => '我相信我還能與NBA高手在場上拼博
#    
#    如果過完一天，我做到了，那很好。
#    
#    如果我未能做到，我也能接受。
#    
#    如果我跌倒了，那就跌倒吧，我會自己站起來，
#    
#    拍拍身上的灰塵，大步向前走。
#    
#    在生命中，我學到的功課是：
#    
#    不要讓任何人來決定你什麼事可以做，
#    
#    什麼事不能做。要相信自己的能力與抉擇，
#    
#    我不想活在別人的期望或幻想中，
#    
#    我走我自己的路
#    
#                        ----麥可喬登')
#    u.great_words.create(:content => '上了賊船 就要當個勇敢海盜')
#    u.great_words.create(:content => '不要把生命看得太嚴肅，
#    
#        反正我們不會活著離開它。
#        
#                                         赫爾福特')
#    u.great_words.create(:content => '世界上最大的麻煩是愚者十分肯定，智者滿腹狐疑。 --塞羅爾')
#    u.great_words.create(:content => '『若真心想突破自己，請把自己與痛苦緊緊綁在一起，
#    
#        任它折磨你到找出答案為止。因為付出才是痛苦的解藥』
#        
#                                    摘錄自《七千萬的工作》')
#    u.great_words.create(:content => '    你可以不懺悔  但你不能不反省
#    
#        你可以不祈禱  但你不能沒有希望
#        
#            你可以沒信仰  但你不能不相信你自己')
#    u.great_words.create(:content => '被別人揭下面具是一種失敗，自己揭下面具卻是一種勝利。')
#    u.great_words.create(:content => '運氣這玩意兒.我深信不疑.而且我還發現.我越努力.運氣越好....英國作家記經濟學家 \ 李考克')
#    u.great_words.create(:content => '原來人生不是只是一句格言那麼簡單')
#    u.great_words.create(:content => '大可不必為了別人的不友善而改變我們原本柔軟的內在')
  end

  def self.down
    drop_table :great_words
  end
end
